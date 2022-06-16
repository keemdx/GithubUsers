//
//  UserListResult.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/15.
//

import Foundation

struct UserModel: Codable {
    var id: Int
    var login: String
    var avatarUrl: String
    var followingUrl: String
    var followersUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case followingUrl = "following_url"
        case followersUrl = "followers_url"
    }
}
