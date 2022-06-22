//
//  DGHContributions.swift
//  DModule
//
//  Created by Mac on 2022/6/20.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup

let kGitHubUserContributionApi = "https://github.com/users/"
typealias DGHContributionHandler = (Array<DGHContributionModel>) -> Void

class DGHContributionsGateway {
    
    var handler: DGHContributionHandler?
    
    func fetchGHContrubution(handler:@escaping DGHContributionHandler) {
        self.handler = handler
        let model = DGHContributionsGatewayModel()
        GHGateway.shared.request(model)
            .response { [weak self] response  in
            switch response.result {
            case .success(let value):
                self?.processResponse(value: value ?? Data())
            case .failure(let error):
                print(error)
            }
        }
       
    }
    
    func processResponse(value: Data) {
        guard let responseStr =  String(data:value, encoding: .utf8) else  {
            return
        }
        do {
            let html = responseStr
            let doc: Document = try SwiftSoup.parse(html)
            let els = try doc.select(".ContributionCalendar-day")
            var modelArray: Array<DGHContributionModel> = []
            for conCalendar: Element in els.array() {
                let count: String = try conCalendar.attr("data-count")
                let date: String = try conCalendar.attr("data-date")
                let level: String = try conCalendar.attr("data-level")
                print(count, date, level)
                
                let model = DGHContributionModel(count: Int(count) ?? 0, date: date, level: Int(level) ?? 0)
                modelArray.append(model)
            }
            
            if let h = self.handler {
                h(modelArray)
            }
        } catch Exception.Error(let type, let message) {
            print(message, type)
        } catch {
            print("error")
        }
    }
    
}

struct DGHContributionsGatewayModel: GHGatewayModelProtocol {
    var accessToken: String {
        get {
            DGHUser.shared.model?.tokenType ?? ""
        }
    }
    
    var url: String {
        get {
            guard let loginName = DGHUser.shared.profile?.login else {
                return ""
            }
            
            let url = "\(kGitHubUserContributionApi)\(loginName)/contributions"
            return url
        }
    }
    
    var method: HTTPMethod {
        get {
            .get
        }
    }
}

