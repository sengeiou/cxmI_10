//
//  ESportsPlayViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2019/3/1.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HandyJSON

class ESportsPlayModel : NSObject {
    required override init() { }
    
    var type : String = ""
    var title : BehaviorSubject<String> = BehaviorSubject(value: "")
    var items : [ESportsItemModel] = [ESportsItemModel]()
    
    var homeItems : [ESportsItemModel] = [ESportsItemModel]()
    var visiItems : [ESportsItemModel] = [ESportsItemModel]()
    
    var seItems : Set<ESportsItemModel> = Set()
}

class ESportsItemModel : NSObject {
    
    required override init() { }
    
    var teamName : String = ""
    
    var text : BehaviorSubject<String>!
    
    var itemBackgroundColor = BehaviorSubject(value: ColorFFFFFF)
    var isSelect = BehaviorSubject(value: false)
}



// MARK: - 玩法投注
protocol ESportsPlay {
    associatedtype Item : ESportsModel
    var data : Item { get set }
    
    var list : [ESportsPlayModel] { get set }
    
    /// 主队名
    var homeTeam : BehaviorSubject<String> { get set }
    /// 客队名
    var visiTeam : BehaviorSubject<String> { get set }
    
    var selectData : Set<ESportsPlayModel> { get set }
    
    mutating func setData(data : Item) -> Void
}
extension ESportsPlay {

    /// 更新数据
    var reloadData : BehaviorSubject<Bool> {
        return BehaviorSubject(value: false)
    }
}

extension ESportsPlay {

    public mutating func sePlayItem(playItem : ESportsPlayModel, index : Int) {
        
        if let isSelect = try? playItem.items[index].isSelect.value() {
            
            let item = playItem.items[index]
            
            item.isSelect.onNext(!isSelect)
            switch isSelect {
            case true: // 取消选中操作
                item.itemBackgroundColor.onNext(ColorFFFFFF)
                playItem.seItems.remove(item)
                
                if playItem.seItems.isEmpty {
                   selectData.remove(playItem)
                }
            case false: // 选取当前Item
                item.itemBackgroundColor.onNext(ColorEA5504)
                playItem.seItems.insert(item)
                selectData.insert(playItem)
            }
        }
    }
    
    public func changeBGColor() {
        
    }
    
}
