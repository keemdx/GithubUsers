//
//  BaseViewController.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/16.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    var users: [UserModel] = []
    
    let usersTableView = UITableView()
    let rightButton = UIButton()
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        addSubviews()
        makeConstraints()
    }
    
    @objc func followClicked(sender: UIButton) {
        
    }
    
    private func setupViews() {
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        setupEmptyBackgroundView()
    }
    
    private func addSubviews() {
        view.addSubview(usersTableView)
    }
    
    private func makeConstraints() {
        usersTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupFollowButton(_ button: UIButton) {
        button.backgroundColor = button.isSelected ? .white : .systemBlue
        button.setTitle(button.isSelected ? "Following" : "Follow", for: .normal)
        button.setTitleColor(button.isSelected ? .black : .white, for: .normal)
        button.layer.borderColor = button.isSelected ?
        UIColor.lightGray.withAlphaComponent(0.5).cgColor : UIColor.systemBlue.cgColor
    }
    
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView()
        usersTableView.backgroundView = emptyBackgroundView
    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
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
        let user = users[indexPath.row]
        cell.setupView(model: user)
        cell.followButton.tag = indexPath.row
        cell.followButton.addTarget(self, action: #selector(followClicked), for: .touchUpInside)
        
        if let myFollowingUsers = UserDefaultsManager.myFollowingUsers {
            if myFollowingUsers.contains(where: { $0.id == user.id }) {
                cell.followButton.isSelected = true
            } else {
                cell.followButton.isSelected = false
            }
            setupFollowButton(cell.followButton)
        }
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
