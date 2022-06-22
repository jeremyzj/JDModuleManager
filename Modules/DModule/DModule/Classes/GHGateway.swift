//
//  GHGateway.swift
//  DModule
//
//  Created by Mac on 2022/6/22.
//

import UIKit
import Alamofire

let kGitHubAccept = "application/vnd.github.v3+json"

protocol GHGatewayModelProtocol {
    var accessToken: String { get }
    var url: String { get }
    var method: HTTPMethod { get }
}

class GHGateway {
    static let shared = GHGateway()
    
    func request<T:GHGatewayModelProtocol>(_ model:T) -> DataRequest {
        let header: HTTPHeaders = ["Accept": kGitHubAccept, "Authorization": "token \(model.accessToken)"]
        
        return AF.request(model.url, method: model.method, headers: header)
    }
}
