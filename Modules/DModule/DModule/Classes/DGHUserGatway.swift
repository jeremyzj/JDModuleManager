//
//  DGHUseGatway.swift
//  DModule
//
//  Created by Mac on 2022/6/4.
//

import Foundation
import Alamofire
import SwiftyJSON

let kGitHubAccept = "application/vnd.github.v3+json"
let kGitHubUserProfileApi = "https://api.github.com/user"

class DGHUserGateway {
    static let shared = DGHUserGateway()
    var profile:DGHUserProfile?
    
    func fetchGHUserInfo(model: DGHModel) {
        let header: HTTPHeaders = ["Accept": kGitHubAccept, "Authorization": "token \(model.accessToken)"]
        
        AF.request(kGitHubUserProfileApi, method: .get, headers: header)
            .response { [weak self] response  in
            switch response.result {
            case .success(let value):
                print(try! JSON(data: value ?? Data()))
                self?.resultUser(info: value ?? Data())
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resultUser(info: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let user: DGHUserProfile = try jsonDecoder.decode(DGHUserProfile.self, from: info)
            profile = user
            print(user)
        } catch (let error) {
            print(error)
        }
    }
}

