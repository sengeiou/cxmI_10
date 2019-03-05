//
//  ESportsLoLModel.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa
import SVProgressHUD





struct LoLData : ESportsModel {
    
    var betDetail: BehaviorSubject<String> = BehaviorSubject(value: "玩法投注")
    
    var id : String = ""
    var homeTeam : String = "RNG"
    var visiTeam : String = "OMG"
    var homeIcon : String = ""
    var visiIcon : String = ""
    var season : String = "LPL春季赛"
    var date : String = "2019.2.1 10:00"

    var play : [LoLPlayData] = [LoLPlayData]()
    
    
    
    var selectPlay : Set<LoLPlayData> = Set()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            homeTeam <-- "team"
    }
    
    
}

extension LoLData {
    var hashValue : Int{
        return
            id.hashValue       ^
            homeTeam.hashValue ^
            visiTeam.hashValue ^
            homeIcon.hashValue ^
            visiIcon.hashValue ^
            season.hashValue
    }
    
    static func == (lhs: LoLData, rhs: LoLData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LoLPlayData : HandyJSON {
    var id = ""
    var title : String = "对局比分"
    var playType : String = "0"
    var homePlay : [LoLPlayItemData] = [LoLPlayItemData]()
    var visiPlay : [LoLPlayItemData] = [LoLPlayItemData]()
}

struct LoLPlayItemData : HandyJSON {
    var title : String = "地图"
    var odds : String = "2.0"
}

extension LoLPlayData : Hashable {
    static func == (lhs: LoLPlayData, rhs: LoLPlayData) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue : Int {
        return
            id.hashValue
    }
}
