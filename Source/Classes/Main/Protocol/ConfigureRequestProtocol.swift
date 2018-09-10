//
//  ConfigureRequestProtocol.swift
//  彩小蜜
//
//  Created by D.Y on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol ConfigureRequestProtocol {
    
}

extension ConfigureRequestProtocol {
    
/*
    {
     "code": "0",
     "data": {
        "businessType": null,
        "channel": "",
        "id": null,
        "platform": null,
        "turnOn": "0",
        "version": ""
        },
     "msg": "success"
    }
*/
  
    func configRequest() {
        _ = userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in
                UserDefaults.standard.set(data.turnOn, forKey: TurnOn)
                UserDefaults.standard.synchronize()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": data.turnOn])
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult: break
                default: break
                }
                
                let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": turnOn])
                
            }, onCompleted: nil, onDisposed: nil )
    }
    
    
}
