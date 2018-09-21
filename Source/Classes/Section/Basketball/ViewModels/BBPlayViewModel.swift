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

class BBPlayModel : NSObject {
    
    var changci : String!
    
    var shengfu : BBPlayInfoModel = BBPlayInfoModel()
    var rangfen  : BBPlayInfoModel = BBPlayInfoModel()
    var daxiaofen : BBPlayInfoModel = BBPlayInfoModel()
    var visiSFC : [BBCellModel] = [BBCellModel]()
    var homeSFC : [BBCellModel] = [BBCellModel]()
    
    
    
    // 交互
    weak var viewModel : BasketballViewModel!
    
    // 胜分差，选择项
    var seSFC : BehaviorSubject = BehaviorSubject(value: [BBCellModel]())
    private var seSFCList : [BBCellModel] = [BBCellModel]() {
        didSet{
            seSFC.onNext(seSFCList)
        }
    }
    // 混合，选取项
    var selectedCellNum : BehaviorSubject = BehaviorSubject(value: 0)
    private var cellNum = 0 {
        didSet{
            selectedCellNum.onNext(cellNum)
        }
    }
    
}

extension BBPlayModel {
    
    private func canSePlay(isSelected : Bool) -> Bool {
        switch isSelected {
        case true:
            guard viewModel.selectMatch(play: self) else { return false }
        case false :
            if cellNum <= 1 {
                viewModel.deSelectMatch(play: self)
            }
            return true
        }
        return true
    }
    // 胜负
    func seSFVisiPlay(isSelected: Bool) {
        shengfu.visiCell.selected = !shengfu.visiCell.selected
        
//        switch shengfu.visiCell.selected {
//        case true:
//            guard viewModel.selectMatch(play: self) else { return }
//        case false :
//            if cellNum <= 1 {
//                viewModel.deSelectMatch(play: self)
//            }
//        }
        
        guard canSePlay(isSelected: shengfu.visiCell.selected) else {
            shengfu.visiCell.selected = false
            return }
        
        shengfu.visiCell.isSelected.onNext(shengfu.visiCell.selected)
        changeCellNum(isSelected: shengfu.visiCell.selected)
    }
    func seSFHomePlay(isSelected: Bool) {
        shengfu.homeCell.selected = !shengfu.homeCell.selected
        guard canSePlay(isSelected: shengfu.homeCell.selected) else {
            shengfu.homeCell.selected = false
            return }
        shengfu.homeCell.isSelected.onNext(shengfu.homeCell.selected)
        changeCellNum(isSelected: shengfu.homeCell.selected)
    }
    // 让分
    func seRFVisiPlay(isSelected : Bool) {
        rangfen.visiCell.selected = !rangfen.visiCell.selected
        guard canSePlay(isSelected: rangfen.visiCell.selected) else {
            rangfen.visiCell.selected = false
            return }
        rangfen.visiCell.isSelected.onNext(rangfen.visiCell.selected)
        changeCellNum(isSelected: rangfen.visiCell.selected)
    }
    func seRFHomePlay(isSelected : Bool) {
        rangfen.homeCell.selected = !rangfen.homeCell.selected
        guard canSePlay(isSelected: rangfen.homeCell.selected) else {
            rangfen.homeCell.selected = false
            return }
        rangfen.homeCell.isSelected.onNext(rangfen.homeCell.selected)
        changeCellNum(isSelected: rangfen.homeCell.selected)
    }
    // 大小分
    func seDXFVisiPlay(isSelected : Bool) {
        daxiaofen.visiCell.selected = !daxiaofen.visiCell.selected
        guard canSePlay(isSelected: daxiaofen.visiCell.selected) else {
            daxiaofen.visiCell.selected = false
            return }
        daxiaofen.visiCell.isSelected.onNext(daxiaofen.visiCell.selected)
        changeCellNum(isSelected: daxiaofen.visiCell.selected)
    }
    func seDXFHomePlay(isSelected : Bool) {
        daxiaofen.homeCell.selected = !daxiaofen.homeCell.selected
        guard canSePlay(isSelected: daxiaofen.homeCell.selected) else {
            daxiaofen.homeCell.selected = false
            return }
        daxiaofen.homeCell.isSelected.onNext(daxiaofen.homeCell.selected)
        changeCellNum(isSelected: daxiaofen.homeCell.selected)
    }
    // 胜分差
    func seSFCVisiPlay(isSelected : Bool, index : Int) {
        let cell = visiSFC[index]
        
        cell.selected = !cell.selected
        
        cell.isSelected.onNext(cell.selected)
        changeCellNum(isSelected: cell.selected)
        
        switch cell.selected {
        case true:
            seSFCList.append(cell)
        case false:
            seSFCList.remove(cell)
        }
        
    }
    func seSFCHomePlay(isSelected : Bool, index : Int) {
        let cell = homeSFC[index]
        cell.selected = !cell.selected
        cell.isSelected.onNext(cell.selected)
        changeCellNum(isSelected: cell.selected)
        
        switch cell.selected {
        case true:
            seSFCList.append(cell)
        case false:
            seSFCList.remove(cell)
        }
    }
    // 设置为选中状态
    func deSeSFCVisiPlay() {
        for (_, cell)  in visiSFC.enumerated() {
            cell.selected = false
            cell.isSelected.onNext(false)
            changeCellNum(isSelected: false)
        }
        seSFCList.removeAll()
    }
    func deSeSFCHomePlay() {
        for (_, cell)  in homeSFC.enumerated() {
            cell.selected = false
            cell.isSelected.onNext(false)
            changeCellNum(isSelected: false)
        }
        seSFCList.removeAll()
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
class BBCellModel : NSObject {
    var selected : Bool = false
    var isSelected : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var bgColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)
    
    var cellName : String = ""
    var cellOdds : String = ""
}

struct BBPlayViewModel {
    var list : [BBPlaySectionModel] = [BBPlaySectionModel]()
}

extension BBPlayViewModel {
    
}
