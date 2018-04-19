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
        
        let allSin = isAllSingle(playList: playList)
        
        if allSin == true {
            let filter = FootballPlayFilterModel()
            filter.title = "单关"
            filter.titleNum = "11"
            filterList.append(filter)
            
            if playList.count < 9{
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
            
        }else {
            
            if playList.count < 2, playList[0].matchPlays[0].single == false{
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
        }
        filterList.last?.isSelected = true
        
        return filterList
    }
    
    func dan() {
        
    }
    
    
    func isAllSingle(playList: [FootballPlayListModel]) -> Bool {
        var allSin = true
        
        for play in playList {
            
            let spf = play.matchPlays[1]
            let rangSpf = play.matchPlays[0]
            let score = play.matchPlays[2]
            let total = play.matchPlays[3]
            let ban = play.matchPlays[4]
            
            if spf.homeCell.isSelected || spf.flatCell.isSelected || spf.visitingCell.isSelected {
                if spf.single == false {
                    allSin = false
                    break
                }
            }
            
            if rangSpf.homeCell.isSelected || rangSpf.flatCell.isSelected || rangSpf.visitingCell.isSelected {
                if rangSpf.single == false {
                    allSin = false
                    break
                }
            }
            
            var scoreSin = false
            for cell in score.homeCell.cellSons {
                if cell.isSelected {
                    scoreSin = true
                    break
                }
            }
            
            for cell in score.flatCell.cellSons {
                if cell.isSelected {
                    scoreSin = true
                    break
                }
            }
            for cell in score.visitingCell.cellSons {
                if cell.isSelected {
                    scoreSin = true
                    break
                }
            }
            for cell in total.matchCells {
                if cell.isSelected {
                    scoreSin = true
                    break
                }
            }
            for cell in ban.matchCells {
                if cell.isSelected {
                    scoreSin = true
                    break
                }
            }
            
            allSin = scoreSin
            
            if allSin == false {
                return allSin
            }
            
        }
        return allSin
    }
    
}
