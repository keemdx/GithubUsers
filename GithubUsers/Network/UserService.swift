//
//  MovieService.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/15.
//

import Foundation

struct UserService {
    static let shared = UserService()
    
    func fetchUserData(urlString: String, completion: @escaping (Result<Any, Error>) -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error : \(error!)")
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([UserModel].self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
}
