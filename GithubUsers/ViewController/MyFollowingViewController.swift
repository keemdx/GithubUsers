//
//  MyFollowingViewController.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/15.
//

import UIKit
import SnapKit

class MyFollowingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFollowingUserData()
    }
    
    func getFollowingUserData() {
        if let datas = UserDefaultsManager.myFollowingUsers {
            self.users = datas.sorted(by: { $0.login.lowercased() < $1.login.lowercased() })
            self.usersTableView.reloadData()
        }
    }
    
    private func setupNavBar() {
        title = "My Following"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc override func followClicked(sender: UIButton) {
        var myFollowingUsers: [UserModel] = []
        
        if let getData = UserDefaultsManager.myFollowingUsers {
            myFollowingUsers = getData
        }
        
        let user = users[sender.tag]
        
        if let index = myFollowingUsers.firstIndex(where: { $0.id == user.id }) {
            myFollowingUsers.remove(at: index)
        }
        
        UserDefaultsManager.myFollowingUsers = myFollowingUsers
        getFollowingUserData()
    }
}

