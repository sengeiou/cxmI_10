//
//  BasketballViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/19.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let maxNum : Int = 3

class BasketballViewModel : AlertPro {
    var selectNumText : BehaviorSubject<String> = BehaviorSubject(value: "请至少选择一场单关比赛\n或两场非单关比赛")
    
    var filterList: [FootballPlayFilterModel] = [FootballPlayFilterModel]()
    
    // 选取的 赛事
    var confirmButtonState : BehaviorSubject = BehaviorSubject(value: false)
    
    var multiple : BehaviorSubject = BehaviorSubject(value: "5")
    
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
        }
    }
    
    private var sePlaySet : Set<BBPlayModel> = Set() {
        didSet{
            sePlayList = sePlaySet.sorted{$0.changci < $1.changci}
        }
    }
    
    public func removeAllSePlay() {
        sePlaySet.removeAll()
    }
}

extension BasketballViewModel {
    public func selectMatch(play : BBPlayModel) -> Bool {
        
        guard sePlaySet.count < maxNum
            || sePlaySet.contains(play) else {

            showHUD(message: "最多选择\(sePlaySet.count)场")

            return false
        }
        
        sePlaySet.insert(play)
        return true
    }
    public func deSelectMatch(play : BBPlayModel) {
        sePlaySet.remove(play)
    }
    
    public func deletePlay(play : BBPlayModel) {
        self.sePlaySet.remove(play)
        
    }
    public func changeMultiple(multiple : String) {
        self.multiple.onNext(multiple)
    }
}

fileprivate var maxChuanguanNum: Set<Int> = [8]
extension BasketballViewModel {
    private func getChuanguan(sePlays : [BBPlayModel]) -> [FootballPlayFilterModel] {
        let list = [FootballPlayFilterModel]()
        
        for play in sePlays {
            switch play.playType {
            case .胜负:
                break
            case .让分胜负:
                break
            case .大小分:
                
                break
            case .胜分差:
                break
            case .混合投注:
                break
            }
        }
        
        
        return list
    }
}
