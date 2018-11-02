//
//  BBSchemeViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SchemeInfo {
    var betInfo : BehaviorSubject = BehaviorSubject(value: "-")
    var passType : BehaviorSubject = BehaviorSubject(value: "-")
    var mulitle : BehaviorSubject = BehaviorSubject(value: "-")
    var state : BehaviorSubject = BehaviorSubject(value: "-")
}

class BBSchemeViewModel {
    
    public var programme : BehaviorSubject = BehaviorSubject(value : NSAttributedString(string: ""))
    
    public var list : [SchemeInfo] = [SchemeInfo]()
}

extension BBSchemeViewModel {
    public func setData(data : OrderSchemeInfoModel, programmeSn: String) {
        let muPro = NSMutableAttributedString(string: "模拟编号: ",
                                              attributes: [NSAttributedStringKey.foregroundColor : ColorA0A0A0])
        let pro = NSAttributedString(string: "\(programmeSn)",
                                        attributes: [NSAttributedStringKey.foregroundColor : Color505050])
        muPro.append(pro)
        
        programme.onNext(muPro)
        
        
        for scheme in data.ticketSchemeDetailDTOs {
            let info = SchemeInfo()
            
            let contents = scheme.tickeContent.components(separatedBy: "X")
            
            var str = ""
            var i = 0
            for content in contents {
            if i == contents.count - 1 {
                str += content
            }else {
                str += content + "X\n"
            }
                i += 1
            }
            
            info.betInfo.onNext(str)
            
            info.mulitle.onNext(scheme.multiple)
            
            info.passType.onNext(scheme.passType)
            
            guard scheme.status != nil else { return }
            switch scheme.status {
            case "0":
                info.state.onNext("待出票")
            case "1":
                info.state.onNext("已出票")
            case "2":
                info.state.onNext("出票失败")
            case "3":
                info.state.onNext("出票中")
            default: break
        
            }
            
            list.append(info)
        }
    }
}
