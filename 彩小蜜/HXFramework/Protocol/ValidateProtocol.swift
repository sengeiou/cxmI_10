//
//  ValidateProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

enum ValidateType : String {
    case phone = "[0-9]{11}"
    case number = "[1-9]\\d*?"
    case password = "[A-Za-z0-9]{6,20}+$"
    case chinese = "[\u{4e00}-\u{9fa5}]+"
    case IDNumber = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
    case bankCard = "(^[0-9]{16}$)|([0-9]{19})"
    case vcode = "[1-9]?"
}

protocol ValidatePro  {
    
}
extension ValidatePro {
    func validate(_ type : ValidateType, str : String?) -> Bool {
        guard str != nil else { return false}
        let numString = type.rawValue
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        return predicate.evaluate(with: str)
    }
}


