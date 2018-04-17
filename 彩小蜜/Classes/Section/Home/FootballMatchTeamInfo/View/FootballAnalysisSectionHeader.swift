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
}

class FootballAnalysisSectionHeader: UITableViewHeaderFooterView {

    public var headerStyle : AnalysisHeaderStyle! {
        didSet{
            switch headerStyle {
            case .标题:
                layoutTitleView()
            case .赛事:
                layoutMatchView()
            case .标题与赛事:
                layoutTitleAndMatchView()
            default : break
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
        title.font = Font16
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
            make.top.left.right.equalTo(0)
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
            make.top.left.right.equalTo(0)
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
