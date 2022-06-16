//
//  DetailViewController.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/15.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var user: UserModel?
    var profileImage: UIImage?
    var isFollowing = false
    
    private var users: [UserModel] = []
    
    let usersTableView = UITableView()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.numberOfLines = 1
        return view
    }()
    
    var segControl: UISegmentedControl = {
        let items = ["Following", "Followers"]
        let view = UISegmentedControl(items: items)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .red
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    override func viewDidLoad() {
        setupDatas()
        setupNavBar()
        setupViews()
        setupTableView()
        addSubviews()
        makeConstraints()
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: isFollowing ? "Following":"Follow!", style: .plain, target: self, action: #selector(self.followAction(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = isFollowing ? .black : .systemBlue
    }
    
    @objc func followAction(sender: UIBarButtonItem) {
        guard let user = user else { return }
        
        var myFollowingUsers: [UserModel] = []
        
        if let getData = UserDefaultsManager.myFollowingUsers {
            myFollowingUsers = getData
        }
        
        if isFollowing == true {
            if let index = myFollowingUsers.firstIndex(where: { $0.id == user.id }) {
                myFollowingUsers.remove(at: index)
            }
            isFollowing = false
        } else {
            myFollowingUsers.append(user)
            isFollowing = true
        }
        
        UserDefaultsManager.myFollowingUsers = myFollowingUsers
        setupNavBar()
    }
    
    private func setupDatas() {
        guard let user = user else { return }
        if let myFollowingUsers = UserDefaultsManager.myFollowingUsers {
            if myFollowingUsers.contains(where: { $0.id == user.id }) {
                self.isFollowing = true
            }
        }
        nameLabel.text = user.login
        
        if let profileImage = profileImage {
            profileImageView.image = profileImage
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        segControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        segControl.selectedSegmentIndex = 0
        didChangeValue(segment: self.segControl)
    }
    
    private func setupTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        setupEmptyBackgroundView()
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        guard let user = user else { return }
        
        var userURL: String?
        switch segment.selectedSegmentIndex {
        case 0:
            userURL = user.followingUrl.replacingOccurrences(of: "{/other_user}", with: "")
        case 1:
            userURL = user.followersUrl
        default:
            break
        }
        if let userURL = userURL {
            print(userURL)
            getUserData(userURL)
        }
    }
    
    func getUserData(_ urlString: String) {
        UserService.shared.fetchUserData(urlString: urlString) { (response) in
            switch response {
            case .success(let userData):
                if let decodedData = userData as? [UserModel] {
                    self.users = decodedData
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                    return
                }
            case .failure(let userData):
                print("Failure : ", userData)
            }
        }
    }
    
    private func addSubviews() {
        [profileImageView, nameLabel, segControl, usersTableView]
            .forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        segControl.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(34)
        }
        
        usersTableView.snp.makeConstraints {
            $0.top.equalTo(segControl.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView()
        usersTableView.backgroundView = emptyBackgroundView
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.setupView(model: users[indexPath.row])
        cell.followButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
        let detailViewController = DetailViewController()
        detailViewController.user = users[indexPath.row]
        detailViewController.profileImage = cell.thumbnailImageView.image
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
