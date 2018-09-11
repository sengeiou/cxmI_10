//
//  SurpriseShooterHeaderModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift

class HeaderDataModel : NSObject {
    required override init() {}
    
    var title : String!
    var selected : Bool = false
    
}

struct ShooterHeaderViewModel {
    
    public var selectedItem = PublishSubject<Int>()
    
    public var headerList : [HeaderDataModel]!
    
    init() {
        headerList = getDataList()
    }
    
    
}

extension ShooterHeaderViewModel {
    
    
    public func selectedItem(index : Int) {
        for model in headerList {
            model.selected = false
        }
        self.headerList[index].selected = true
        
        self.selectedItem.onNext(index)
    }
    
    public func getDataList() -> [HeaderDataModel] {
        var list = [HeaderDataModel]()
        
        let data1 = HeaderDataModel()
        data1.title = "英超-射手榜"
        data1.selected = true
        
        let data2 = HeaderDataModel()
        data2.title = "德甲-射手榜"
        
        let data3 = HeaderDataModel()
        data3.title = "意甲-射手榜"
        
        let data4 = HeaderDataModel()
        data4.title = "西甲-射手榜"
        
        let data5 = HeaderDataModel()
        data5.title = "法甲-射手榜"
        
        
        list.append(data1)
        list.append(data2)
        list.append(data3)
        list.append(data4)
        list.append(data5)
        
        return list
    }
}
