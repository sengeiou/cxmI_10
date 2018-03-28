//
//  AccountListModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class AccountListModel {
    var title : String!
    var list: [AccountDetailModel] = [AccountDetailModel]()
    
    public class func getAccountList(_ list : [Any]) -> [AccountListModel]! {
        var accountList = [AccountListModel]()
        
        guard let accList = list as? [AccountDetailModel] else { return []}
        
        var i = 0
        for acc in accList {
            if i == 0{
                let listModel = AccountListModel()
                listModel.title = acc.addTime
                accountList.append(listModel)
            }else {
                if acc.addTime != accountList.last!.title {
                    let listModel = AccountListModel()
                    listModel.title = acc.addTime
                    accountList.append(listModel)
                }
            }
            i += 1
        }
        for index in 0 ..< accountList.count {
            let lis = accountList[index]
            var arr = [AccountDetailModel]()
            for acc in accList {
                if lis.title == acc.addTime {
                    arr.append(acc)
                }
            }
            lis.list = arr
        }
        return accountList
    }
    
}
