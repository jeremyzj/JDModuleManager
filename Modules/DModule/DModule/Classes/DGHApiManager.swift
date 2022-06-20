//
//  DGHApiManager.swift
//  DModule
//
//  Created by Mac on 2022/6/3.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 授权api
let authPath: String = "https://github.com/login/oauth/authorize"

/// 获取github token
let accessPath: String = "https://github.com/login/oauth/access_token"

class GHApiManager {
    
    let clientID: String = "0c38367461b0660b3ae6"
    let clientSecret: String = "c22f349db13dcb1d37c8b2f5823ce215c5382294"
    
    static let shared = GHApiManager()
    var dghModel:DGHModel?
    
    func openGithubWeb() {
        let authPath:String = "\(authPath)?client_id=\(clientID)&scope=repo&state=TEST_STATE"
        guard let authURL: URL = URL(string: authPath) else {
            return
        }

        UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
    }
    
    
    func auth(url: URL) {
        guard let receiveCode = processOAuthCodeResponse(url: url) else {
            return
        }
        

        let params = ["client_id": clientID, "client_secret": clientSecret, "code": receiveCode]
        
        AF.request(accessPath, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .response {
            [weak self] response  in
            switch response.result {
            case .success(let value):
                self?.processOAuthTokenResponse(value: value ?? Data())
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func processOAuthTokenResponse(value: Data) {
        guard let responseStr =  String(data:value, encoding: .utf8) else  {
            return
        }
        
        let resultParams:Array<String> = responseStr.split(separator: "&").map{ String($0) }
        let dghModel = DGHModel(paramsArray: resultParams)
        self.dghModel = dghModel
        
        DGHUserGateway.shared.fetchGHUserInfo(model: dghModel)
    }
    
    func processOAuthCodeResponse(url: URL)-> String? {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }// NSURLComponents(NS: url, resolvingAgainstBaseURL: false)
        guard let queryItem = components.queryItems else {
            return nil
        }
        
        var code : String? = nil
        for item in queryItem {
            if item.name.lowercased() == "code" {
                code = item.value
                break
            }
        }
        
        return code

    }
}
