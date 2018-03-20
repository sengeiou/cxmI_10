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

extension Observable where E == Response {
    func mapBaseObject<T: HandyJSON>(type: T.Type) -> Observable<T> {
        return map { response in
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw HXError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw HXError.NoResponse
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
                print("""
                    ************************************
                    
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
            
            guard json["code"] as! String == "0", var data = json["data"] as? [String: Any] else {
                throw HXError.UnexpectedResult(resultCode: json["code"] as? String , resultMsg: json["msg"] as? String )
            }
            
           
            data["showMsg"] = json["msg"] as! String
            
            return JSONDeserializer<T>.deserializeFrom(dict: data)!
        }
    }
    
    func mapArray<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
        return map { response in
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                print("""
                    ************************************
                    
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
                throw HXError.UnexpectedResult(resultCode: json["code"] as? String , resultMsg: json["msg"] as? String )
            }
            
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
    // 解析失败
    case ParseJSONError
    // 网络请求发生错误
    case RequestFailed
    // 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: String?, resultMsg: String?)
}

enum RequestStatus: Int {
    case requestSuccess = 200
    case requestError
}
