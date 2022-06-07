//
//  DGHModel.swift
//  DModule
//
//  Created by Mac on 2022/6/4.
//

import Foundation
import Alamofire

enum DGHModelEnum: String {
    case token = "access_token"
    case scope = "scope"
    case type  = "token_type"
}

struct DGHModel {
    var accessToken: String = ""
    var scope: String = ""
    var tokenType: String = ""
    
    init(paramsArray: Array<String>) {
        for param in paramsArray {
            print(param)
            let paramValues:Array<String> = param.split(separator: "=").map{ String($0) }
            if paramValues.count < 2 {
                continue
            }
            
            let valueKey: String = paramValues[0]
            let value: String = paramValues[1]
            if valueKey == DGHModelEnum.token.rawValue {
                accessToken = value
            } else if valueKey == DGHModelEnum.scope.rawValue {
                scope = value
            } else {
                tokenType = value
            }
        }
    }
}
