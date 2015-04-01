//
//  TMBaseNetworkManager.swift
//  ThinMe
//
//  Created by ZhangMing on 3/1/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit
import Alamofire


enum TMRequestStatus: Int {
    case Succeeful = 2000
    case TMRequestStatusFailed = 2001
    case DataNotExist = 3001
    case DataExist = 3002
    case PasswordError = 3003
    case UserForbidden = 3004       // 用户已被禁止
    case AccountTypeError = 3005    // 帐户类型错误(需要判断用户帐号类型时)
}

class TMNetworkManager: NSObject {
    
    var manager: NetworkManager
    
    override init() {
        manager = NetworkManager.sharedInstance
        super.init()
    }
    
    func request(method: Alamofire.Method, relativePath path: String, parameters: [String: AnyObject]?, completion: NetworkCompletionClosure) {
        manager.request(method, relativePath: path, parameters: parameters) { (result) -> Void in
            self.handleResult(result, completion: completion)
        }
    }
    
    // handle error
    func handleResult(result: Result, completion: NetworkCompletionClosure) {
        var error: NSError?
        switch (result) {
        case let .Error(e):
            completion(result)
        case let .Value(json):
            // parse error code
            var errorCode = json["status"]
            println(json)
            // error
            if errorCode.int != TMRequestStatus.Succeeful.rawValue {
                error = NSError(domain: "error", code: errorCode.intValue, userInfo: nil)
                var _result = Result(error, json)
                completion(_result)
            } else {
                completion(result)
            }
        }
    }
}
