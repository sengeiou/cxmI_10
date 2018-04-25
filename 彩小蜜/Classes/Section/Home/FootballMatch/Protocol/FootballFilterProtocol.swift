//
//  FootballFilterProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/4/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

fileprivate var maxNum: Set<Int> = [8]

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
            
            if playList.count <= maxNum.min()!{
                for index in 2..<playList.count + 1 {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }else {
                for index in 2...maxNum.min()! {
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
            }else if playList.count <= maxNum.min()!{
                for index in 2..<playList.count + 1 {
                    let filter = FootballPlayFilterModel()
                    filter.playTitle = "串关  "
                    filter.title = "\(index)串1"
                    filter.titleNum = "\(index)1"
                    filterList.append(filter)
                }
            }else {
                for index in 2...maxNum.min()! {
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
        
        maxNum.removeAll()
        maxNum.insert(8)
        
        for play in playList {
            
            
            if play.matchPlays.count == 1 {
                let match = play.matchPlays[0]
                if match.homeCell != nil && match.visitingCell != nil && match.flatCell != nil {
                    if match.homeCell.isSelected || match.flatCell.isSelected || match.visitingCell.isSelected {
                        if match.single == false {
                            allSin = false
                            break
                        }
                    }
                }
                
                if match.flatCell == nil && match.homeCell != nil && match.visitingCell != nil {
                    if match.homeCell.isSelected || match.visitingCell.isSelected {
                        if match.single == false {
                            allSin = false
                            break
                        }
                    }
                }
                
                var scoreSin = false
                
                if match.homeCell != nil && match.homeCell.cellSons != nil {
                    for cell in match.homeCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                    for cell in match.flatCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                    for cell in match.visitingCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                }
                
                if match.matchCells != nil {
                    for cell in match.matchCells {
                        if cell.isSelected {
                            scoreSin = true
                            if match.playType == "4" {
                                maxNum.insert(6)
                            }else if match.playType == "5" {
                                maxNum.insert(4)
                            }
                            break
                        }
                    }
                }
//                if match.matchCells != nil {
//                    for cell in match.matchCells {
//                        if cell.isSelected {
//                            scoreSin = true
//                            break
//                        }
//                    }
//                }
                
                
                
                allSin = scoreSin
                
                if allSin == false {
                    return allSin
                }
                
            }else {
                
                let spf = play.matchPlays[1]
                let rangSpf = play.matchPlays[0]
                let score = play.matchPlays[2]
                let total = play.matchPlays[3]
                let ban = play.matchPlays[4]
                
                
                var scoreSin = false
                
                if score.homeCell.cellSons != nil {
                    for cell in score.homeCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                    for cell in score.flatCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                    for cell in score.visitingCell.cellSons {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                }
                
                if total.matchCells != nil {
                    for cell in total.matchCells {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(6)
                            break
                        }
                    }
                }
                if ban.matchCells != nil {
                    for cell in ban.matchCells {
                        if cell.isSelected {
                            scoreSin = true
                            maxNum.insert(4)
                            break
                        }
                    }
                }
                
                if spf.homeCell != nil {
                    if spf.homeCell.isSelected || spf.flatCell.isSelected || spf.visitingCell.isSelected {
                        if spf.single == false {
                            allSin = false
                            //break
                        }
                    }
                }
                
                if rangSpf.homeCell != nil {
                    if rangSpf.homeCell.isSelected || rangSpf.flatCell.isSelected || rangSpf.visitingCell.isSelected {
                        if rangSpf.single == false {
                            allSin = false
                            //break
                        }
                    }
                }
                
                allSin = scoreSin
                
//                if allSin == false {
//                    return allSin
//                }
            }
            
            
            
            
        }
        return allSin
    }
    
}
