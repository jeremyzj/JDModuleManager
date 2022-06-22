//
//  DGHUseGatway.swift
//  DModule
//
//  Created by Mac on 2022/6/4.
//

import Foundation
import Alamofire
import SwiftyJSON

let kGitHubUserProfileApi = "https://api.github.com/user"

class DGHUserGateway {
    
    func fetchGHUserInfo() {
        let model = DGHUserGatewayModel()
        
        GHGateway.shared.request(model)
            .response { [weak self] response  in
            switch response.result {
            case .success(let value):
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
            DGHUser.shared.profile = user
            print(user)
        } catch (let error) {
            print(error)
        }
    }
}



struct DGHUserGatewayModel: GHGatewayModelProtocol {
    var accessToken: String {
        get {
            DGHUser.shared.model?.accessToken ?? ""
        }
    }
    
    var url: String {
        get {
            kGitHubUserProfileApi
        }
    }
    
    var method: HTTPMethod {
        get {
            .get
        }
    }
}



