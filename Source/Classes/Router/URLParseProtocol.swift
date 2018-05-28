//
//  URLParseProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol URLParseProtocol {
    
}

extension URLParseProtocol {
    func parseUrl(urlStr: String) -> URLModel?{
        var urlModel = URLModel()
        
        guard urlStr.contains("&"), urlStr.contains("?") else { return nil }
    
        guard let com = urlStr.components(separatedBy: "?").last else { return nil }
        let urlComponents = com.components(separatedBy: "&")
        
        var i = 0
        for keyValue in urlComponents {
            let components = keyValue.components(separatedBy: "=")
            
            let key = components.first ?? ""
            let value = components.last ?? ""
            if key == "type" {
                urlModel.type = value
            }else if key == "id" {
                urlModel.id = value
            }else if key == "subid" {
                urlModel.subid = value
            }else if key == "cmshare" {
                urlModel.cmshare = value
            }else if key == "usinfo" {
                urlModel.usInfo = value
            }
            
            i += 1
        }
        return urlModel
    }
}
