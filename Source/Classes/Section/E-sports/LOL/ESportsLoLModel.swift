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



struct ESportsLoLModel : ESportsLottery {
    typealias Item = ESportsLoLData
    
    var data: [ESportsLoLData] = [ESportsLoLData(),ESportsLoLData()]
   
}




struct ESportsLoLData : ESportsModel {
    
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

extension ESportsLoLData {
    var hashValue : Int{
        return
            id.hashValue       ^
            homeTeam.hashValue ^
            visiTeam.hashValue ^
            homeIcon.hashValue ^
            visiIcon.hashValue ^
            season.hashValue
    }
    
    static func == (lhs: ESportsLoLData, rhs: ESportsLoLData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LoLPlayData : HandyJSON {
    var id = ""
}

extension LoLPlayData : Hashable {
    var hashValue : Int {
        return
            id.hashValue
    }
}
