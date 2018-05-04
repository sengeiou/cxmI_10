//
//  RequestPlugin.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import Moya
import Result
import SVProgressHUD

public final class RequestLoadingPlugin:PluginType{
    
    public func willSend(_ request: RequestType, target: TargetType) {
        print("""
            
            ^^^^^^^^****************************
            
            token   :    \(String(describing: request.request?.allHTTPHeaderFields!["token"]))
            url     :    \(String(describing: request.request?.url))
            
            ************************************
            
            """)
        //self.showHUD()
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        //self.dismissHUD();
    }
    //MARK:-是否显示请求加载框
    fileprivate  func  showHUD(_ isShow:Bool = true){
        if(isShow){
            SVProgressHUD.show();
        }
    }
    
    //MARK:-隐藏请求加载框
    fileprivate  func dismissHUD(){
        SVProgressHUD.dismiss();
    }
}
