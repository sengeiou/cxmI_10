//
//  FootballFilterProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/4/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol FootballFilterPro { }

extension FootballFilterPro {
    func filterPlay(with playList: [FootballPlayListModel]) -> [FootballPlayFilterModel]! {
        guard playList.isEmpty == false else { return nil }
        var filterList = [FootballPlayFilterModel]()
        if playList.count < 2, playList[0].single == true {
            let filter = FootballPlayFilterModel()
            filter.title = "单关"
            filter.titleNum = "11"
            filterList.append(filter)
        }else if playList.count < 2, playList[0].single == false{
            let filter = FootballPlayFilterModel()
            filter.playTitle = "串关  "
            filter.title = "2串1"
            filter.titleNum = "21"
            filterList.append(filter)
        }else if playList.count < 9{
            for index in 2..<playList.count + 1 {
                let filter = FootballPlayFilterModel()
                filter.playTitle = "串关  "
                filter.title = "\(index)串1"
                filter.titleNum = "\(index)1"
                filterList.append(filter)
            }
        }else {
            for index in 2...8 {
                let filter = FootballPlayFilterModel()
                filter.playTitle = "串关  "
                filter.title = "\(index)串1"
                filter.titleNum = "\(index)1"
                filterList.append(filter)
            }
        }
        filterList.last?.isSelected = true
        
        return filterList
    }
    
    func dan() {
        
    }
}
