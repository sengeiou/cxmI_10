//
//  BBConfirmViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let maxNum : Int = 15

class BBConfirmViewModel : AlertPro, DateProtocol {
    
    var lotteryClassifyId: String = ""
    var lotteryPlayClassifyId: String = ""
    
    var selectNumText : BehaviorSubject<String> = BehaviorSubject(value: "请至少选择一场单关比赛\n或两场非单关比赛")
    
    var betTitle : BehaviorSubject = BehaviorSubject(value: "")
    var betNum : BehaviorSubject = BehaviorSubject(value: "")
    var multiple : BehaviorSubject = BehaviorSubject(value: "5")
    var shouldRequest : BehaviorSubject = BehaviorSubject(value: true)
    
    var danIsSelect : BehaviorSubject = BehaviorSubject(value: false)
    ///顶部显示的文本
    var topText : BehaviorSubject<NSAttributedString> = BehaviorSubject(value: NSAttributedString(string: ""))
    
    private var filterList: [FootballPlayFilterModel] = [FootballPlayFilterModel]() {
        didSet{
            
            
        }
    }
    private var danMax = 0 {
        didSet{
            if danMax <= 0 {
                for play in sePlayList {
                    if play.isDanSe == false {
                        play.canChangeDan(canSet: false)
                    }
                }
            }else {
                for play in sePlayList {
                    if play.isDanSe == false {
                        play.canChangeDan(canSet: true)
                    }
                }
            }
        }
    }
    
    var confirmButtonState : BehaviorSubject = BehaviorSubject(value: false)
    
    var sePlays : BehaviorSubject = BehaviorSubject(value: [BBPlayModel]())
    
    public var deSePlayList = [BBPlayModel]()
    
    public var sePlayList = [BBPlayModel]() {
        didSet{
            
            if sePlayList.isEmpty {
                selectNumText.onNext("请至少选择一场单关比赛\n或两场非单关比赛")
                confirmButtonState.onNext(false)
            }else if sePlayList.count == 1 {
                let play = sePlayList[0]
                
                if play.shengFenCha.single == true {
                    selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                    confirmButtonState.onNext(true)
                }else {
                    if play.shengfu.single || play.rangfen.single || play.daxiaofen.single {
                        selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                        confirmButtonState.onNext(true)
                    }else{
                        selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                        confirmButtonState.onNext(false)
                    }
                }
            }
            else {
                selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                confirmButtonState.onNext(true)
            }
            
            getChuanguan(sePlays: sePlayList)
            
            if oldValue.count != sePlayList.count {
                self.sePlays.onNext(self.sePlayList)
                
                changeTopText()
            }
        }
    }
    
    var sePlaySet : Set<BBPlayModel> = Set() {
        didSet{
            sePlayList = sePlaySet.sorted{$0.changci < $1.changci}
            
        }
    }
    
    public func removeAllSePlay() {
        sePlaySet.removeAll()
    }
    
    
    private func changeTopText() {
        var arr = [Int]()
        for model in sePlayList {
            arr.append(model.playInfo.betEndTime)
        }
        
        guard let timeInt = arr.min() else { return }
        
        let time = timeStampToHHmm(timeInt)
        
        let attStr = NSMutableAttributedString(string: "已选\(sePlayList.count)场比赛 投注截止时间：", attributes: [NSAttributedString.Key.foregroundColor: Color9F9F9F])
        let att = NSAttributedString(string: time, attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
        attStr.append(att)
        
        self.topText.onNext(attStr)
    }
    
}

extension BBConfirmViewModel {
    // 胜负
    public func seSFVisiPlay(play : BBPlayModel) {
        play.seSFVisiPlay()
        
        switch play.shengfu.visiCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                play.isDanSe = false
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        
        shouldRequest.onNext(true)
    }
    public func seSFHomePlay(play : BBPlayModel) {
        play.seSFHomePlay()
        switch play.shengfu.homeCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                play.isDanSe = false
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        shouldRequest.onNext(true)
    }
    // 让分胜负
    public func seRFVisiPlay(play : BBPlayModel) {
        play.seRFVisiPlay()
        
        switch play.rangfen.visiCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                play.isDanSe = false
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        
        shouldRequest.onNext(true)
    }
    public func seRFHomePlay(play : BBPlayModel) {
        play.seRFHomePlay()
        switch play.rangfen.homeCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                setDan(play: play)
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        shouldRequest.onNext(true)
    }
    // 大小分
    public func seDXFVisiPlay(play : BBPlayModel) {
        play.seDXFVisiPlay()
        
        switch play.daxiaofen.visiCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                setDan(play: play)
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        
        shouldRequest.onNext(true)
    }
    public func seDXFHomePlay(play : BBPlayModel) {
        play.seDXFHomePlay()
        switch play.daxiaofen.homeCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                setDan(play: play)
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        shouldRequest.onNext(true)
    }
    // 胜分差
    public func seSFCVisiPlay(play : BBPlayModel, index : Int) {
        play.seSFCVisiPlay(index: index)
        
        switch play.shengFenCha.visiCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                setDan(play: play)
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        
        shouldRequest.onNext(true)
    }
    public func seSFCHomePlay(play : BBPlayModel, index : Int) {
        play.seSFCHomePlay(index: index)
        switch play.shengFenCha.homeCell.selected {
        case true:
            self.sePlaySet.insert(play)
        case false :
            if play.cellNum <= 0 {
                setDan(play: play)
                play.canChangeDan(canSet: false)
                self.sePlaySet.remove(play)
            }
        }
        shouldRequest.onNext(true)
    }
}


extension BBConfirmViewModel {

    
    public func deletePlay(play : BBPlayModel) {
        self.sePlaySet.remove(play)
        shouldRequest.onNext(true)
    }
    public func changeMultiple(multiple : String) {
        self.multiple.onNext(multiple)
        shouldRequest.onNext(true)
    }
}

// MARK: - 胆
extension BBConfirmViewModel {
    public func setDan(play : BBPlayModel) {
        
        play.isDanSe = !play.isDanSe
        
        switch play.isDanSe {
        case true:
            
            guard danMax > 0 else {
                play.isDanSe = false
                play.changeDan(isDan: play.isDanSe)
                return
            }
            play.changeDan(isDan: play.isDanSe)
            danMax -= 1
        case false:
            danMax += 1
            play.changeDan(isDan: play.isDanSe)
        }
        
        shouldRequest.onNext(true)
    }
    private func backDan() {
        for play in sePlayList {
            play.changeDan(isDan: false)
        }
        
        for play in deSePlayList {
            play.changeDan(isDan: false)
        }
    }
    private func setDanMaxNum() {
        guard let betNum = try? self.betNum.value() else {
            for play in sePlayList {
                play.canChangeDan(canSet: false)
            }
            return }
        guard let betNumber = betNum.components(separatedBy: ",").first?.first?.description else {
            for play in sePlayList {
                play.canChangeDan(canSet: false)
            }
            return }
        guard let filter = filterList.last else {
            for play in sePlayList {
                play.canChangeDan(canSet: false)
            }
            return }
        guard let bet = Int(betNumber) else { return }
        guard let num = Int((filter.titleNum.first?.description)!) else { return }
        if bet < num {
            danMax = bet - 1
            for play in sePlayList {
                play.canChangeDan(canSet: true)
            }
        }else {
            danMax = 0
            for play in sePlayList {
                play.canChangeDan(canSet: false)
            }
        }
    }
}
// MARK: - 串关
fileprivate var maxChuanguanNum: Set<Int> = [8]
extension BBConfirmViewModel {
    
    public func getFilterList() -> [FootballPlayFilterModel] {
        return self.filterList
    }
    
    public func changeChuanguan() {
        var title = ""
        var filterNum = ""
        
        for filter in filterList {
            if filter.isSelected {
                title += filter.title + ","
                filterNum += filter.titleNum + ","
            }
        }
        
        if title != "" {
            title.removeLast()
        }
        if filterNum != "" {
            filterNum.removeLast()
        }
        self.betTitle.onNext(title)
        self.betNum.onNext(filterNum)
        
        backDan()
        setDanMaxNum()
        
    }
    
    private func getChuanguan(sePlays : [BBPlayModel]) {
        guard sePlays.isEmpty == false else { return }
        filterList.removeAll()
        
        switch isAllSingle(sePlays: sePlays) {
        case true:
            let filter = FootballPlayFilterModel()
            filter.title = "单关"
            filter.titleNum = "11"
            filterList.append(filter)
            
            if sePlays.count <= maxChuanguanNum.min()!{
                for index in 2..<sePlays.count + 1 {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }else {
                for index in 2...maxChuanguanNum.min()! {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }
            
        default:
            if sePlays.count < 2{
                let filter = FootballPlayFilterModel()
                filter.playTitle = "串关  "
                filter.title = "场次不足"
                filter.titleNum = "01"
                filterList.append(filter)
            }else if sePlays.count <= maxChuanguanNum.min()!{
                for index in 2..<sePlays.count + 1 {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }else {
                for index in 2...maxChuanguanNum.min()! {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }
        }
        
        filterList.last?.isSelected = true
        changeChuanguan()
    }
    
    private func isAllSingle(sePlays : [BBPlayModel]) -> Bool {
        var allSingle = true
        
        for play in sePlays {
            switch play.playType {
            case .胜负:
                if play.shengfu.single == false{
                    allSingle = false
                }
            case .让分胜负:
                if play.rangfen.single == false {
                    allSingle = false
                }
            case .大小分:
                if play.daxiaofen.single == false {
                    allSingle = false
                }
                
            case .胜分差:
                maxChuanguanNum.insert(4)
                for cell in play.shengFenCha.visiSFC {
                    
                }
                for cell in play.shengFenCha.homeSFC {
                    
                }
            case .混合投注:
                if play.shengfu.visiCell.selected || play.shengfu.homeCell.selected {
                    if play.shengfu.single == false {
                        allSingle = false
                    }
                }
                if play.rangfen.visiCell.selected || play.rangfen.homeCell.selected {
                    if play.rangfen.single == false {
                        allSingle = false
                    }
                }
                if play.daxiaofen.visiCell.selected || play.daxiaofen.homeCell.selected {
                    if play.daxiaofen.single == false {
                        allSingle = false
                    }
                }
                
                for cell in play.shengFenCha.visiSFC {
                    if cell.selected {
                        maxChuanguanNum.insert(4)
                    }
                }
                for cell in play.shengFenCha.homeSFC {
                    if cell.selected {
                        maxChuanguanNum.insert(4)
                    }
                }
                
                
            }
        }
        
        return allSingle
    }
    
}
