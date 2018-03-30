//
//  FootballSectionHeader.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum FootballHeaderType {
    case hotMatch
    case match
}

protocol FootballSectionHeaderDelegate {
    func spread(sender: UIButton, section : Int) -> Void
}

class FootballSectionHeader: UITableViewHeaderFooterView {

    public var matchModel : FootballMatchModel! {
        didSet{
            if matchModel.title != nil {
                title.text = "热门比赛"
                title.textColor = ColorEA5504
            }else{
                title.text = "今日" + matchModel.matchDay + "共有"
                + "\(matchModel.playList.count)" + "场比赛可投"
                title.textColor = Color787878
            }
        }
    }
    
    public var headerType: FootballHeaderType = .match {
        didSet{
            switch headerType {
            case .hotMatch:
                title.textColor = ColorEA5504
                icon.isHidden = false
                title.snp.makeConstraints({ (make) in
                    make.left.equalTo(icon.snp.right).offset(10)
                })
            case .match:
                title.textColor = Color787878
                icon.isHidden = true
                title.snp.makeConstraints({ (make) in
                    make.left.equalTo(leftSpacing)
                })
            }
        }
    }
    public var delegate : FootballSectionHeaderDelegate!
    
    
    private var icon : UIImageView!
    private var title : UILabel!
    private var spreadBut : UIButton!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(30)
        }
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(spreadBut.snp.left).offset(-10)
        }
        spreadBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(-rightSpacing)
            make.width.height.equalTo(20)
        }
    }
    private func initSubview() {
        self.contentView.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        icon.image = UIImage(named: "Datasecurity")
        
        title = UILabel()
        title.font = Font15
        title.textAlignment = .left
        title.text = "热门比赛"
        
        spreadBut = UIButton(type: .custom)
        spreadBut.setImage(UIImage(named: "jump"), for: .normal)
        spreadBut.addTarget(self, action: #selector(spreadClicked(_:)), for: .touchUpInside)
        spreadBut.isSelected = true
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(spreadBut)
    }
    
    @objc private func spreadClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard delegate != nil else { return }
        delegate.spread(sender: sender, section: self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
