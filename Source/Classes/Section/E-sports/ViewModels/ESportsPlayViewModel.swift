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

enum ItemType {
    case homeTeam // 主队
    case visiTeam // 客队
}
enum PlayType : String {
    case 获胜方 = "0"
    case 对局比分 = "1"
    case 对局总数 = "2"
    case 地图获胜 = "3"
    case 获得一血 = "4"
    case 防御塔 = "5"
    case 水晶 = "6"
    case 大龙 = "7"
    case 小龙 = "8"
    
}
class ESportsPlayModel : NSObject {
    required override init() { }
    
    var playType : PlayType = .获胜方
    
    var data : LoLPlayData!
    
    var title : String = ""
    
    var titleBgColor : UIColor = ColorEA5504
    
    var homeItems : [ESportsItemModel] = [ESportsItemModel]()
    var visiItems : [ESportsItemModel] = [ESportsItemModel]()
    
    var seItems : Set<ESportsItemModel> = Set()
    var temSeItems : Set<ESportsItemModel> = Set()
    var itemWidth : CGFloat = 40.0
    let itemheight : CGFloat = 40.0
    var cellHeight : CGFloat = 40.0
}

class ESportsItemModel : NSObject {
    
    required override init() { }
    
    var teamName : String = ""
    
    var attText : BehaviorSubject<NSAttributedString>!
    
    var itemBackgroundColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)

    var deText : NSAttributedString!
    var seText : NSAttributedString!
    
    
    var isSelected : Bool = false {
        didSet{
            switch isSelected {
            case true:
                self.attText.onNext(self.seText)
                self.itemBackgroundColor.onNext(ColorEA5504)
            case false:
                self.attText.onNext(self.deText)
                self.itemBackgroundColor.onNext(ColorFFFFFF)
            }
        }
    }
    
}



// MARK: - 玩法投注
protocol ESportsPlay {
    associatedtype Item : ESportsModel
    var data : Item { get set }
    
    var list : [ESportsPlayModel] { get set }
    
    /// 主队名
    var homeTeam : String { get set }
    /// 客队名
    var visiTeam : String { get set }
    
    /// 所有选中项
    var selectData : Set<ESportsPlayModel> { get set }
    
    /// 临时的选中项
    var temSeData : Set<ESportsPlayModel> { get set }
    
    mutating func setData(data : Item) -> Void
}
extension ESportsPlay {

    /// 更新数据
    var reloadData : BehaviorSubject<Bool> {
        return BehaviorSubject(value: false)
    }
}

extension ESportsPlay {

    /// 选取Item
    public mutating func sePlayItem(play : ESportsPlayModel, type : ItemType, index : Int) {
        switch type {
        case .homeTeam:
            let item = play.homeItems[index]
            changeSelectType(item: item, play: play)
        case .visiTeam:
            let item = play.visiItems[index]
            changeSelectType(item: item, play: play)
        }
    }
    
    /// 移除所有选中项
    public mutating func removeAllSelect() {
        for data in selectData {
            for item in data.homeItems {
                item.isSelected = false
            }
            for item in data.visiItems {
                item.isSelected = false
            }
        }
        temSeData.removeAll()
        selectData.removeAll()
    }
    /// 确定按钮
    public mutating func confirm() {
        // 合并两个结合
        selectData = selectData.union(temSeData)
        
        for play in temSeData {
            play.seItems = play.seItems.union(play.temSeItems)
        }
    }
    
    
}

extension ESportsPlay {
    // 改变选中状态
    private mutating func changeSelectType(item : ESportsItemModel, play : ESportsPlayModel) {
        
        item.isSelected = !item.isSelected
        switch item.isSelected {
        case true: // 取消选中操作
            play.temSeItems.insert(item)
            temSeData.insert(play)
        case false: // 选取当前Item
            play.temSeItems.remove(item)
            if play.seItems.isEmpty {
                temSeData.remove(play)
            }
        }
    }
}
