//
//  BasketballModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa


class BasketballDataModel : HandyJSON {
    required init() { }
    
    var list : [BasketballMatchModel] = [BasketballMatchModel]()
    var allMatchCount: String = ""
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
}

class BasketballMatchModel: HandyJSON {
    required init() { }
    
    var isSpreading : Bool = true
    var playList: [BasketballListModel] = [BasketballListModel]()
    var matchDay: String = ""
    var title: String = ""
    var allMatchCount: String = ""
    
}

class BasketballMatchList : HandyJSON {
    required init() { }
    
    var allMatchCount: String = ""
    var playList: [BasketballMatchModel]!
    var hotPlayList: [BasketballListModel]!
    var leagueInfos: [FilterModel]!
    var lotteryClassifyId: String = ""
    var lotteryPlayClassifyId: String = ""

}

class BasketballListModel: HandyJSON {
    required init() { }
    /// 是否停售
    var isShutDown : Bool! = false
    /// 停售原因
    var shutDownMsg : String = ""
    var changci: String = ""
    var changciId: String = ""
    var isDan : Bool! = false
    var homeTeamAbbr: String = ""
    var homeTeamId: String = ""
    /// 排名
    var homeTeamRank: String = ""
    var isHot : Bool!
    var leagueAddr: String = ""
    var leagueId: String = ""
    var leagueName: String = ""
    var matchDay: String = ""
    var matchTime: Int!
    var betEndTime : Int!
    var matchId: String = ""
    var playCode: String = ""
    var playContent: String = ""
    var playType: String = ""
    var visitingTeamAbbr: String = ""
    var visitingTeamId: String = ""
    var visitingTeamName: String = ""
    /// 排名
    var visitingTeamRank: String = ""
    var matchPlays : [BasketbalPlayInfo] = [BasketbalPlayInfo]()
}

class BasketbalPlayInfo : HandyJSON {
    required init() { }
    var fixedOdds: String!
    
    var homeCell: BasketballPlayCellInfo!
    var visitingCell: BasketballPlayCellInfo!
    var matchCells : [BasketballPlayCellInfo]!
    var playContent: String = ""
    var playType: String = ""
    /// 单关，1-单关，0不可以
    var single: Bool = false
    var isShow: Bool = true
}
class BasketballPlayCellInfo : HandyJSON {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = BasketballPlayCellInfo()
        model.isSelected = isSelected
        model.cellCode = cellCode
        model.cellName = cellName
        model.cellOdds = cellOdds
        model.cellSons = cellSons
        model.isRang = isRang
        return model
    }
    
    required init() { }
    var isSelected = BehaviorSubject(value: false)
    var cellCode: String = ""
    var cellName: String = ""
    var cellOdds: String = ""
    var cellSons: [BasketballPlayCellInfo] = [BasketballPlayCellInfo]()
    var isRang = false
    
    func seleCell(isSelected : Bool) {
        self.isSelected.onNext(isSelected)
    }
    
}
