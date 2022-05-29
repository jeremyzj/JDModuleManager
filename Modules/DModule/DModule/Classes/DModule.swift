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
    public func dService1() {
        print("d servie1")
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
