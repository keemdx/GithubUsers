//
//  UserDefaultsManager.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/16.
//

import Foundation

struct UserDefaultsManager {
    
    @UserDefaultsWrapper(key: UserDefaultsKey.MY_FOLLOWING_USERS, defaultValue: nil)
    static var myFollowingUsers: [UserModel]?
}
