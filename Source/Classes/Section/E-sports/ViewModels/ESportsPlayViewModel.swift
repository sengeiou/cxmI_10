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
    
    var itemWidth : CGFloat = 40.0
    let itemheight : CGFloat = 40.0
    var cellHeight : CGFloat = 40.0
}

class ESportsItemModel : NSObject {
    
    required override init() { }
    
    var teamName : String = ""
    
    var attText : BehaviorSubject<NSAttributedString>!
    
    var itemBackgroundColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)
    var isSelect = BehaviorSubject(value: false)
    
    var deText : NSAttributedString!
    var seText : NSAttributedString!
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
    
    private mutating func changeSelectType(item : ESportsItemModel, play : ESportsPlayModel) {
        
        if let isSelect = try? item.isSelect.value() {
            
            item.isSelect.onNext(!isSelect)
            switch isSelect {
            case true: // 取消选中操作
                item.attText.onNext(item.deText)
                item.itemBackgroundColor.onNext(ColorFFFFFF)
                play.seItems.remove(item)
                
                if play.seItems.isEmpty {
                    selectData.remove(play)
                }
            case false: // 选取当前Item
                
                item.attText.onNext(item.seText)
                
                item.itemBackgroundColor.onNext(ColorEA5504)
                
                play.seItems.insert(item)
                selectData.insert(play)
            }
        }
    }
    
    public func changeBGColor() {
        
    }
    
}
