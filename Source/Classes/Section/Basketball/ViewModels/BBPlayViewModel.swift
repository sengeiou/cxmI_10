//
//  BBPlayViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BBPlaySectionModel {
    var playType : BasketballPlayType = .混合投注
    var list : [BBPlayModel] = [BBPlayModel]()
}
class BBPlayModel {
    
    var changci : String!
    
    var shengfu : BBPlayInfoModel = BBPlayInfoModel()
    var rangfen  : BBPlayInfoModel = BBPlayInfoModel()
    var daxiaofen : BBPlayInfoModel = BBPlayInfoModel()
    var shengfencha  : [BBCellModel] = [BBCellModel]()
    
    
    
    // 交互
    
    var selectedCellNum : BehaviorSubject = BehaviorSubject(value: 0)
    
    private var cellNum = 0 {
        didSet{
            selectedCellNum.onNext(cellNum)
        }
    }
    
}

extension BBPlayModel {
    func seSFVisiPlay(isSelected: Bool) {
        shengfu.visiCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    func seSFHomePlay(isSelected: Bool) {
        shengfu.homeCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    
    // 让分
    func seRFVisiPlay(isSelected : Bool) {
        rangfen.visiCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    func seRFHomePlay(isSelected : Bool) {
        rangfen.homeCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    // 大小分
    func seDXFVisiPlay(isSelected : Bool) {
        daxiaofen.visiCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    func seDXFHomePlay(isSelected : Bool) {
        daxiaofen.homeCell.isSelected.onNext(isSelected)
        changeCellNum(isSelected: isSelected)
    }
    
    private func changeCellNum(isSelected : Bool) {
        switch isSelected {
        case true:
            cellNum += 1
        case false:
            if cellNum > 0{
                cellNum -= 1
            }
        }
    }
}


class BBPlayInfoModel {
    var homeCell : BBCellModel = BBCellModel()
    var visiCell : BBCellModel = BBCellModel()
}
class BBCellModel {
    var isSelected : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var bgColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)
}

struct BBPlayViewModel {
    var list : [BBPlaySectionModel] = [BBPlaySectionModel]()
}

extension BBPlayViewModel {
    
}
