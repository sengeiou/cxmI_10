//
//  CourseTabCellViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CourseTabDataModel {
    var title : String = ""
    var select : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
}

class CourseTabCellViewModel {
    var list : [CourseTabDataModel] = [CourseTabDataModel]()
    var reloadData : BehaviorSubject<Int> = BehaviorSubject(value: 0)
    var showTitle : BehaviorSubject<String> = BehaviorSubject(value: "")
    private var selectIndex : Int = 0
}

extension CourseTabCellViewModel {
    
    public func selectedItem(model : CourseTabDataModel, index : Int) {
    
        selectIndex = index
        
        changeSelected()
    }
    
    public func leftShift() -> Bool {
        
        guard selectIndex != 0 else { return true }
        
        selectIndex -= 1
        
        changeSelected()
        return false
    }
    public func rightShift() -> Bool {
        guard list.count > 1 else { return true}
        guard selectIndex != list.count - 1 else { return true}
        selectIndex += 1
        
        changeSelected()
        return false
    }
    
    public func setData(data : [LeagueMatchDataList]) {
        for model in data {
            var course = CourseTabDataModel()
            
            course.title = model.turnGroupName
            
            list.append(course)
        }
        
        
        // 设置默认选中的 Item
        let mo = list[0]
        mo.select.onNext(true)
        reloadData.onNext(0)
        showTitle.onNext(mo.title)
        selectIndex = 0
    }
    
    private func changeSelected() {
        for data in list {
            data.select.onNext(false)
        }
        
        let model = list[selectIndex]
        
        model.select.onNext(true)
        reloadData.onNext(selectIndex)
        showTitle.onNext(model.title)
    }
    
}
