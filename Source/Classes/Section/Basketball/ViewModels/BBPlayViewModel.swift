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
import HandyJSON


class BBPlaySectionModel {
    var playType : BasketballPlayType = .混合投注
    var list : [BBPlayModel] = [BBPlayModel]()
}

class BBPlayModel : NSObject {
    
    var playInfo : BasketballListModel!
    
    var changci : String!
    var isDanSe : Bool = false
    var playType : BasketballPlayType = .混合投注
    
    var visiTeam : String = ""
    var homeTeam : String = ""
    
    
    
    var shengfu : BBPlayInfoModel = BBPlayInfoModel()
    var rangfen  : BBPlayInfoModel = BBPlayInfoModel()
    var daxiaofen : BBPlayInfoModel = BBPlayInfoModel()
    var shengFenCha : BBPlayInfoModel = BBPlayInfoModel()
    
    // 选中的Cell
    var seCellList : [BBCellModel] = [BBCellModel]()
    
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
    var cellNum = 0 {
        didSet{
            selectedCellNum.onNext(cellNum)
        }
    }
    // 胆
    var isDan : BehaviorSubject = BehaviorSubject(value: false)
    
    var canSetDan : BehaviorSubject = BehaviorSubject(value: false)
    
    // 临时CellList:
    var cacheCellList : Set<BBCellModel> = Set()
}

extension BBPlayModel {
    public func changeDan(isDan : Bool) {
        isDanSe = isDan
        self.isDan.onNext(isDanSe)
    }
    public func canChangeDan(canSet : Bool) {
        self.canSetDan.onNext(canSet)
    }
}

extension BBPlayModel {
    
    public func removeSe() {
        self.shengfu.homeCell.selected = false
        self.shengfu.visiCell.selected = false
        self.shengfu.homeCell.isSelected.onNext(false)
        
        self.shengfu.homeCell.selected = false
        self.shengfu.visiCell.selected = false
        self.shengfu.homeCell.isSelected.onNext(false)
        self.shengfu.visiCell.isSelected.onNext(false)
        
        self.rangfen.homeCell.selected = false
        self.rangfen.visiCell.selected = false
        self.rangfen.homeCell.isSelected.onNext(false)
        self.rangfen.visiCell.isSelected.onNext(false)
        
        self.daxiaofen.homeCell.selected = false
        self.daxiaofen.visiCell.selected = false
        self.daxiaofen.homeCell.isSelected.onNext(false)
        self.daxiaofen.visiCell.isSelected.onNext(false)
        
        for cell in self.shengFenCha.homeSFC {
            cell.selected = false
            cell.isSelected.onNext(false)
        }
        for cell in self.shengFenCha.visiSFC {
            cell.selected = false
            cell.isSelected.onNext(false)
        }
       
        self.seCellList.removeAll()
        cellNum = 0
    }
    
    public func backSelect(cellNumber : Int) {
        for cell in cacheCellList {
            cell.selected = !cell.selected
            cell.isSelected.onNext(cell.selected)
            changeCellNum(isSelected: cell.selected)
            selectCells(cell: cell)
            
            if cell.playType == "3" {
                switch cell.selected {
                case true:
                    seSFCList.append(cell)
                case false:
                    seSFCList.remove(cell)
                }
            }
        }
        cacheCellList.removeAll()
        if cellNumber <= 0 {
            viewModel.deSelectMatch(play: self)
        }

    }
    
    private func selectCells(cell : BBCellModel) {
        switch cell.selected {
        case true:
            seCellList.append(cell)
        case false:
            seCellList.remove(cell)
        }
    }
    // 胜负
    func seSFVisiPlay(isSelected: Bool = false) {
        shengfu.visiCell.selected = !shengfu.visiCell.selected
        
        guard canSePlay(isSelected: shengfu.visiCell.selected) else {
            shengfu.visiCell.selected = false
            return }
        
        shengfu.visiCell.isSelected.onNext(shengfu.visiCell.selected)
        changeCellNum(isSelected: shengfu.visiCell.selected)
        selectCells(cell: shengfu.visiCell)
    }
    func seSFHomePlay(isSelected: Bool = false) {
        shengfu.homeCell.selected = !shengfu.homeCell.selected
        guard canSePlay(isSelected: shengfu.homeCell.selected) else {
            shengfu.homeCell.selected = false
            return }
        shengfu.homeCell.isSelected.onNext(shengfu.homeCell.selected)
        changeCellNum(isSelected: shengfu.homeCell.selected)
        selectCells(cell: shengfu.homeCell)
    }
    // 让分
    func seRFVisiPlay(isSelected : Bool = false) {
        rangfen.visiCell.selected = !rangfen.visiCell.selected
        guard canSePlay(isSelected: rangfen.visiCell.selected) else {
            rangfen.visiCell.selected = false
            return }
        rangfen.visiCell.isSelected.onNext(rangfen.visiCell.selected)
        changeCellNum(isSelected: rangfen.visiCell.selected)
        selectCells(cell: rangfen.visiCell)
    }
    func seRFHomePlay(isSelected : Bool = false) {
        rangfen.homeCell.selected = !rangfen.homeCell.selected
        guard canSePlay(isSelected: rangfen.homeCell.selected) else {
            rangfen.homeCell.selected = false
            return }
        rangfen.homeCell.isSelected.onNext(rangfen.homeCell.selected)
        changeCellNum(isSelected: rangfen.homeCell.selected)
        selectCells(cell: rangfen.homeCell)
    }
    // 大小分
    func seDXFVisiPlay(isSelected : Bool = false) {
        daxiaofen.visiCell.selected = !daxiaofen.visiCell.selected
        guard canSePlay(isSelected: daxiaofen.visiCell.selected) else {
            daxiaofen.visiCell.selected = false
            return }
        daxiaofen.visiCell.isSelected.onNext(daxiaofen.visiCell.selected)
        changeCellNum(isSelected: daxiaofen.visiCell.selected)
        selectCells(cell: daxiaofen.visiCell)
    }
    func seDXFHomePlay(isSelected : Bool = false) {
        daxiaofen.homeCell.selected = !daxiaofen.homeCell.selected
        guard canSePlay(isSelected: daxiaofen.homeCell.selected) else {
            daxiaofen.homeCell.selected = false
            return }
        daxiaofen.homeCell.isSelected.onNext(daxiaofen.homeCell.selected)
        changeCellNum(isSelected: daxiaofen.homeCell.selected)
        selectCells(cell: daxiaofen.homeCell)
    }
    // 胜分差
    func seSFCVisiPlay(isSelected : Bool = false, index : Int) {
        let cell = shengFenCha.visiSFC[index]
        
        cell.selected = !cell.selected
        
        guard canSePlay(isSelected: cell.selected) else {
            cell.selected = false
            return
        }
        
        cell.isSelected.onNext(cell.selected)
        changeCellNum(isSelected: cell.selected)
        
        switch cell.selected {
        case true:
            seSFCList.append(cell)
        case false:
            seSFCList.remove(cell)
        }
        selectCells(cell: cell)
       
    }
    func seSFCHomePlay(isSelected : Bool = false, index : Int) {
        let cell = shengFenCha.homeSFC[index]
        cell.selected = !cell.selected
        
        guard canSePlay(isSelected: cell.selected) else {
            cell.selected = false
            return
        }
        
        cell.isSelected.onNext(cell.selected)
        changeCellNum(isSelected: cell.selected)
        
        switch cell.selected {
        case true:
            seSFCList.append(cell)
        case false:
            seSFCList.remove(cell)
        }
        selectCells(cell: cell)
    }
    // 设置为选中状态
    func deSeSFCVisiPlay() {
        for (_, cell)  in shengFenCha.visiSFC.enumerated() {
            cell.selected = false
            cell.isSelected.onNext(false)
            changeCellNum(isSelected: false)
        }
        seSFCList.removeAll()
    }
    func deSeSFCHomePlay() {
        for (_, cell)  in shengFenCha.homeSFC.enumerated() {
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
}


class BBPlayInfoModel {
    var homeCell : BBCellModel = BBCellModel()
    var visiCell : BBCellModel = BBCellModel()
    
    var visiSFC : [BBCellModel] = [BBCellModel]()
    var homeSFC : [BBCellModel] = [BBCellModel]()
    
    var single: Bool = false
    var isShow: Bool = true
    var fixOdds : String = ""
}
class BBCellModel : NSObject , HandyJSON{
    
    required override init() {}
    
    var selected : Bool = false
    var isSelected : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var bgColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)
    
    var playType : String = ""
    var cellName : String = ""
    var cellOdds : String = ""
    var cellCode : String = ""
}

struct BBPlayViewModel {
    var list : [BBPlaySectionModel] = [BBPlaySectionModel]()
}

extension BBPlayViewModel {
    
}
