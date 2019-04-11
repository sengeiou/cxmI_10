//
//  FootballAnalysisSectionHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum AnalysisHeaderStyle {
    case 标题
    case 标题与赛事
    case 赛事
    case 主队
    case 客队
}

class FootballAnalysisSectionHeader: UITableViewHeaderFooterView {

    public var teamInfo : MatchTeamInfoModel! {
        didSet{
            guard teamInfo != nil else { return }
            let homeAtt = NSAttributedString(string: "\(teamInfo.win!)胜", attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
            let flatAtt = NSAttributedString(string: "\(teamInfo.draw!)平", attributes: [NSAttributedString.Key.foregroundColor: Color65AADD])
            let visiAtt = NSAttributedString(string: "\(teamInfo.lose!)负", attributes: [NSAttributedString.Key.foregroundColor: Color44AE35])
            switch headerStyle {
            case .标题:
                let muAtt = NSMutableAttributedString(string: "历史交锋 ")
                let attOne = NSAttributedString(string: "近\(teamInfo.total!)场比赛 主队 ", attributes: [NSAttributedString.Key.foregroundColor: Color9F9F9F])
                
                muAtt.append(attOne)
                muAtt.append(homeAtt)
                muAtt.append(flatAtt)
                muAtt.append(visiAtt)
                
                title.attributedText = muAtt
            case .主队:
                
                let muAtt = NSMutableAttributedString(string: "最近战绩 ", attributes :  [NSAttributedString.Key.foregroundColor: Color505050])
                let attOne = NSAttributedString(string: "\(teamInfo.total!)场比赛  ", attributes : [NSAttributedString.Key.foregroundColor: Color9F9F9F])
                let homeAttTitle = NSAttributedString(string: "\(teamInfo.teamAbbr!) (主队) ", attributes : [NSAttributedString.Key.foregroundColor: Color9F9F9F])
                
                muAtt.append(attOne)
                muAtt.append(homeAttTitle)
                muAtt.append(homeAtt)
                muAtt.append(flatAtt)
                muAtt.append(visiAtt)
                
                title.attributedText = muAtt
            case .客队:
                let muAtt = NSMutableAttributedString(string: "最近战绩 ", attributes : [NSAttributedString.Key.foregroundColor: Color505050])
                let attOne = NSAttributedString(string: "\(teamInfo.total!)场比赛  ", attributes : [NSAttributedString.Key.foregroundColor: Color9F9F9F])
                let homeAttTitle = NSAttributedString(string: "\(teamInfo.teamAbbr!) (客队) ", attributes : [NSAttributedString.Key.foregroundColor: Color9F9F9F])
                muAtt.append(attOne)
                muAtt.append(homeAttTitle)
                muAtt.append(homeAtt)
                muAtt.append(flatAtt)
                muAtt.append(visiAtt)
                title.attributedText = muAtt
            default : break
            }
            
        }
    }
    
    public var headerStyle : AnalysisHeaderStyle = .标题 {
        didSet{
//            guard headerStyle != nil else { return }
            switch headerStyle {
            case .标题:
                layoutTitleView()
            case .赛事:
                layoutMatchView()
            case .标题与赛事, .主队, .客队:
                layoutTitleAndMatchView()
//            default : break
            }
        }
    }
    
    // MARK: - 属性 private
    private var title : UILabel!
    private var matchView: FootballAnalysisMatchView!
    private var line : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        
        self.contentView.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorC8C8C8
        
        title = UILabel()
        title.font = Font14
        title.textColor = Color505050
        title.textAlignment = .left
        title.text = "历史交锋"
        
        matchView = FootballAnalysisMatchView()
        
    }
    
    private func layoutTitleView() {
        remove()
        self.contentView.addSubview(title)
        self.contentView.addSubview(line)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(16 * defaultScale)
            make.top.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
        }
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    private func layoutTitleAndMatchView() {
        remove()
        self.contentView.addSubview(title)
        self.contentView.addSubview(matchView)
        self.contentView.addSubview(line)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(16 * defaultScale)
            make.top.right.equalTo(0)
            make.height.equalTo(44 * defaultScale)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        matchView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    private func layoutMatchView() {
        remove()
        self.contentView.addSubview(matchView)
        self.contentView.addSubview(line )
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        matchView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
        }
    }
    
    private func remove() {
        line.removeFromSuperview()
        matchView.removeFromSuperview()
        title.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
