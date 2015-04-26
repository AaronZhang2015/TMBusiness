//
//  NetworkManager.swift
//  ThinMe
//
//  Created by ZhangMing on 3/1/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

let ServerAddress = "http://www.xunmitech.com/tBeaconService/BeaconService.asmx/"
//let ServerAddress = "http://192.168.1.20/tBeaconService/BeaconService.asmx/"
//let ServerAddress = "http://112.124.125.21/tBeaconService/BeaconService.asmx/"

// 网络请求状态
public enum RequestStatus: Int {
    case Timeout = -1001
    case Disconnected = -1002
    case Unknown = 0
}

public enum Result {
    case Error(NSError)
    case Value(JSON)
    
    init(_ e: NSError?, _ v: JSON) {
        if let ex = e {
            self = Result.Error(ex)
        } else {
            self = Result.Value(v)
        }
    }
}

public typealias NetworkCompletionClosure = (Result) -> Void

public class NetworkManager: NSObject{
    
    public var baseURLString: String!
    
    public class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        
        Manager.sharedInstance.session.configuration.timeoutIntervalForRequest = 30
        return Singleton.instance
    }
    
    override init() {
        super.init()
        self.baseURLString = ServerAddress
    }
    
    func request(method: Alamofire.Method, relativePath path: String?, parameters: [String: AnyObject]?, completion: NetworkCompletionClosure) {
        var URLString: String = baseURLString
        
        if path != nil {
            URLString += path!
        }
        
        self.request(method, path: URLString, parameters: parameters, completion: completion)
    }
    
    func request(method: Alamofire.Method, path: String, parameters: [String: AnyObject]?, completion: NetworkCompletionClosure) {
        var request = Alamofire.request(method, path, parameters: parameters)
        request.response { (request, response, data, error) -> Void in
            var result: Result
            let value = JSON(data: data as! NSData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            switch value.type {
            case .Null:
                result = Result(value.error, value)
            default:
                result = Result(error, value)
            }
            completion(result)
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

/*
public protocol ResponseConvertible {
    typealias Result
    class func convertFromData(data: NSData) -> (Result?, NSError?)
}

extension JSON: ResponseConvertible {
    public typealias Result = JSON
    
    public static func convertFromData(data: NSData) -> (Result?, NSError?) {
        let value = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        switch value.type {
        case .Null:
            return (value, value.error)
        default:
            return (value, nil)
        }
    }
}

extension NSData: ResponseConvertible {
    public typealias Result = NSData
    
    public class func convertFromData(data: NSData) -> (Result?, NSError?) {
        return (data, nil)
    }
}

extension UIImage: ResponseConvertible {
    public typealias Result = UIImage
    
    public class func convertFromData(data: NSData) -> (UIImage?, NSError?) {
        return (UIImage(data: data), nil)
    }
}
*/