//
//  LoLViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa
import SVProgressHUD

/// 投注页ViewModel
struct LoLModel : ESportsLottery, AlertPro {
    typealias Item = LoLData
    
    var data: [LoLData] = [LoLData]()
    
}
extension LoLModel {
    func request() {
        
        _ = eSportsProvider.rx.request(.lolList).asObservable()
            .mapObject(type: LoLData.self)
            .subscribe(onNext: { (data) in
                
            }, onError: { (error) in
                
            }, onCompleted: nil , onDisposed: nil)
    }
}



/// 玩法
struct LoLPlayModel : ESportsPlay {
    
    // 选中的数据
    var selectData: Set<ESportsPlayModel> = Set()
    
    var homeTeam: String = ""
    var visiTeam: String = ""
    
    typealias Item = LoLData
    
    var data: LoLData = LoLData() // 原数据
    
    var list: [ESportsPlayModel] = [ESportsPlayModel]()
    
}
extension LoLPlayModel {
    
    mutating func setData(data: LoLData) {
        self.data = data
        homeTeam = data.homeTeam
        visiTeam = data.visiTeam
        
        for playData in data.play {
            
            let play = ESportsPlayModel()
            play.data = playData
            play.title = playData.title
            play.playType = PlayType(rawValue: playData.playType) ?? .获胜方
            
            for item in playData.homePlay {
                let odd = getESportsItemModel(item: item, type: play.playType)
                play.homeItems.append(odd)
            }
            for item in playData.visiPlay {
                let odd = getESportsItemModel(item: item, type: play.playType)
                play.visiItems.append(odd)
            }
            
            switch play.playType {
            case .获胜方:
                play.titleBgColor = ColorF5AD41
            case .对局比分:
                play.titleBgColor = Color85A5E0
            case .对局总数:
                play.titleBgColor = Color64AADD
            case .地图获胜:
                play.titleBgColor = Color6CD5C4
            case .获得一血:
                play.titleBgColor = ColorE86D8E
            case .防御塔:
                play.titleBgColor = Color5D53B5
            case .水晶:
                play.titleBgColor = Color1B57AB
            case .大龙:
                play.titleBgColor = Color5E89E0
            case .小龙:
                play.titleBgColor = Color429992
            }
            
            list.append(play)
        }
        
        
        for item in list {
            if item.homeItems.count == 1 {
//                item.cellHeight = item.cellHeight * 1
            }else if item.homeItems.count == 3 {
                item.itemWidth = (screenWidth - 73) / 3 - 0.1
                
                item.cellHeight = item.cellHeight * 2
                
            }else if item.homeItems.count == 4 {
                item.itemWidth = (screenWidth - 73) / 4  - 0.1
                item.cellHeight = item.cellHeight * 2
            }else {
                item.itemWidth = (screenWidth - 73) / 5 - 0.1
                
                item.cellHeight = item.cellHeight * 2
            }
        }
        
        reloadData.onNext(true)
    }
    
    
    private func getESportsItemModel(item : LoLPlayItemData, type : PlayType) -> ESportsItemModel {
        
        var title = ""
        var odd = ""
        
        switch type {
        case .获胜方, .防御塔, .水晶, .大龙, .小龙:
            title = item.odds
            odd = item.title
        default:
            title = item.title
            odd = item.odds
        }
        
        let model = ESportsItemModel()
        
        let muAtt = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.font : Font14
            ,NSAttributedString.Key.foregroundColor : Color505050])
        let att = NSAttributedString(string: odd, attributes: [NSAttributedString.Key.font : Font10
            ,NSAttributedString.Key.foregroundColor : Color9F9F9F])
        
        muAtt.append(att)
        
        let semuAtt = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.font : Font14
            ,NSAttributedString.Key.foregroundColor : ColorFFFFFF])
        let seatt = NSAttributedString(string: odd, attributes: [NSAttributedString.Key.font : Font10
            ,NSAttributedString.Key.foregroundColor : ColorFFFFFF])
        
        semuAtt.append(seatt)
    
        model.deText = muAtt
        model.seText = semuAtt
        
        model.attText = BehaviorSubject(value: muAtt)
        
        return model
    }
    
}


/// 投注确认页ViewModel
struct LoLConfirmModel : ESportsConfirm {
    typealias Item = LoLData
    
    
}
