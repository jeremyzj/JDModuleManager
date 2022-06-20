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

class DGHContributionsGateway {
    
    static let shared = DGHContributionsGateway()
    var profile:DGHUserProfile?
    
    func fetchGHContrubution(model: DGHModel) {
        let header: HTTPHeaders = ["Accept": kGitHubAccept, "Authorization": "token \(model.accessToken)"]
        
        guard let loginName = profile?.login else {
            return
        }
        
        let url = "\(kGitHubUserContributionApi)\(loginName)/contributions"
        
        AF.request(url, method: .get, headers: header)
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
            for conCalendar: Element in els.array() {
                let count: String = try conCalendar.attr("data-count")
                let date: String = try conCalendar.attr("data-date")
                let level: String = try conCalendar.attr("data-level")
                print(count, date, level)
            }
            
//            print(els)
        } catch Exception.Error(let type, let message) {
            print(message, type)
        } catch {
            print("error")
        }
    }
    
}
