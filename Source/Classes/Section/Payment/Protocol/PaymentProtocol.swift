//
//  PaymentProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/24.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol PaymentProtocol {
    
}

extension PaymentProtocol {
    func weixinPay(payment : PaymentWeixinModel) {
        let request = PayReq()
        
        WXApi.send(request)
    }
    
}
