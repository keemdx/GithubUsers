//
//  ViewController.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/13.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }
    
    func getUserData() {
        let userURL = "https://api.github.com/users"
        
        UserService.shared.fetchUserData(urlString: userURL) { (response) in
            switch response {
            case .success(let userData):
                if let decodedData = userData as? [UserModel] {
                    self.users = decodedData.sorted(by: { $0.login.lowercased() < $1.login.lowercased() })
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
    
    private func setupNavBar() {
        title = "User List"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "My Following", style: .plain, target: self, action: #selector(self.goToMyFollowingViewController(sender:)))
    }
    
    @objc func goToMyFollowingViewController(sender: UIBarButtonItem) {
        let myFollowingViewController = MyFollowingViewController()
        self.navigationController?.pushViewController(myFollowingViewController, animated: true)
    }
    
    @objc override func followClicked(sender: UIButton) {
        var myFollowingUsers: [UserModel] = []
        
        if let getData = UserDefaultsManager.myFollowingUsers {
            myFollowingUsers = getData
        }
        
        let user = users[sender.tag]
        
        if !sender.isSelected {
            sender.isSelected = true
            myFollowingUsers.append(user)
            
        } else {
            sender.isSelected = false
            if let index = myFollowingUsers.firstIndex(where: { $0.id == user.id }) {
                myFollowingUsers.remove(at: index)
            }
        }
        
        UserDefaultsManager.myFollowingUsers = myFollowingUsers
        setupFollowButton(sender)
    }
}
