//
//  APIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import RxSwift
import Moya


let publicParamEndpointClosure = { (target: LoginNetAPIManager) -> Endpoint in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    let endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.parameterEncoding as? [String : String])
    return endpoint.adding(newHTTPHeaderFields: ["Content-Type" : "application/json"])
}

let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<HomeNetAPIManager>.RequestResultClosure) in
    
    var requests = try! endpoint.urlRequest()
    
    requests.timeoutInterval = 20    //设置请求超时时间
    done(.success(requests))
}


