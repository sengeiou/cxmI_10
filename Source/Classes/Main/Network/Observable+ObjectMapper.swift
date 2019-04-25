//
//  Observable+ObjectMapper.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON
import PKHUD

fileprivate let Show500Title = "出问题了程序猿小哥哥正在修复"

extension Observable where E == Response {
    func mapBaseObject<T: HandyJSON>(type: T.Type) -> Observable<T> {
        return map { response in
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                HUD.flash(.label(Show500Title), delay: 1.5)
                print("""
                    ************statusCode****************
                    
                    statusCode   :    \(response.statusCode)
                    URL          :    \(response.request?.url)
                    
                    ************************************
                    """)
                throw HXError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw HXError.NoResponse
            }
            
            guard json["code"] as! String == "0" else {
                
                guard let codeStr = json["code"] as? String else { throw HXError.ParseCodeError }
                guard let code = Int(codeStr) else { throw HXError.ParseCodeError }
                
                throw HXError.UnexpectedResult(resultCode: code , resultMsg: json["msg"] as? String )
            }
            
            
            print(json["msg"] as! String)
            let jsonString = String.init(data: response.data, encoding: .utf8)
            return JSONDeserializer<T>.deserializeFrom(json: jsonString)!
        }
    }
    
    func mapObject<T: HandyJSON>(type: T.Type) -> Observable<T> {
        return map { response in
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                HUD.flash(.label(Show500Title), delay: 1.5)
                print("""
                    ************statusCode****************
                    
                    statusCode   :    \(response.statusCode)
                    URL          :    \(response.request?.url)
                    
                    ************************************
                    """)
                throw HXError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw HXError.NoResponse
            }
            
            print("""
                    ************************************
                    code   :    \(json["code"] as! String)
                    msg    :    \(json["msg"] as! String)
                    URL    :    \(String(describing: response.request?.url))
                    TOKEN  :    \(UserInfoManager().getToken())
                    ************************************
                """)
            
            guard json["code"] as! String == "0", var data = json["data"] as? [String: Any] else {
                
                guard let codeStr = json["code"] as? String else { throw HXError.ParseCodeError }
                guard let code = Int(codeStr) else { throw HXError.ParseCodeError }
                
                throw HXError.UnexpectedResult(resultCode: code , resultMsg: json["msg"] as? String)
            }

            data["showMsg"] = json["msg"] as! String
            
            DispatchQueue.global().async {
//                print("""
//                    ********---------数据----------******
//                    
//                    \(data)
//                    
//                    ************************************
//                    """)
            }
            return JSONDeserializer<T>.deserializeFrom(dict: data)!
        }
    }
    
    func mapArray<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
        return map { response in
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                HUD.flash(.label(Show500Title), delay: 1.5)
                print("""
                    ************************************
                    url          :    \(String(describing: response.request?.url))
                    statusCode   :    \(response.statusCode)
                    
                    ************************************
                    """)
                throw HXError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw HXError.NoResponse
            }
            
            print("""
                ************************************
                
                code   :    \(json["code"] as! String)
                msg    :    \(json["msg"] as! String)
                URL    :    \(String(describing: response.request?.url))
                TOKEN  :    \(UserInfoManager().getToken())
                
                ************************************
                """)
            
            guard json["code"] as! String == "0", let data = json["data"] as? [[String: Any]] else {
                
                guard let codeStr = json["code"] as? String else { throw HXError.ParseCodeError }
                guard let code = Int(codeStr) else { throw HXError.ParseCodeError }
            
                throw HXError.UnexpectedResult(resultCode: code , resultMsg: json["msg"] as? String )
            }
            
//            DispatchQueue.global().async {
//                print("""
//                    ********---------数据----------******
//                
//                    \(data)
//                
//                    ************************************
//                """)
//            }
            
            guard let objcArr : [T] = JSONDeserializer<T>.deserializeModelArrayFrom(array: data) as? [T] else {
                throw HXError.ParseJSONError
            }
        
            return objcArr
        }
    }
}

extension ObservableType where E == Response {
    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapModel(T.self))
        }
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
        
        let jsonString = String.init(data: data, encoding: .utf8)
        
        
        
        return JSONDeserializer<T>.deserializeFrom(json: jsonString, designatedPath : "data")!
    }
}


enum HXError : Swift.Error {
    /// code 解析错误
    case ParseCodeError
    /// 解析失败
    case ParseJSONError
    /// 网络请求发生错误
    case RequestFailed
    /// 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: Int, resultMsg: String?)
}

enum RequestStatus: Int {
    case requestSuccess = 200
    case requestError
}
