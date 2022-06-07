//
//  DModule.swift
//  DModule
//
//  Created by Mac on 2022/5/29.
//


import JDModuleManager
import JDModuleRouter
import JDModuleService
import Foundation

@objc(DModule)
public class DModule: NSObject, JDModuleRegisterProtocol, DModuleServiceProtocol {
    public func dModuleAuth(_ url: URL) -> Bool {
        GHApiManager.shared.auth(url: url)
        
        return true
    }
    
//    let octocatApi = "https://api.github.com/users/octocat"
    
    public func dService1() {
        
        if let _ = DGHUserGateway.shared.profile {
            if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                let vc = DGHProfileViewController()
                nav.pushViewController(vc, animated: true)
            }
        } else {
            GHApiManager.shared.openGithubWeb()
        }
    }
    
    
    public func registModuleRoutes() -> [String] {
        return [kDRouter2, kDRouter1]
    }
    
    public func handleRoute(withScheme scheme: String, host: String, path: String, params: [AnyHashable : Any]) -> Bool {
        
        let router = "\(scheme)://\(host)"
        
        if router == kDRouter1 {
            print("k d router1")
        } else if router == kDRouter2 {
            print("k d router2")
        }
        
        return false
    }
    
    public func registModuleServices() -> [JDModuleServiceInfo] {
        let info = JDModuleServiceInfo()
        info.protocol = DModuleServiceProtocol.self
        info.implClass = DModule.self
        return [info]
    }
    
}


extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
    
    func flatMap2<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}
