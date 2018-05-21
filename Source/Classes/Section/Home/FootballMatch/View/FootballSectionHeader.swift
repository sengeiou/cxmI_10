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

class FootballSectionHeader: UITableViewHeaderFooterView, DateProtocol {

    public var matchModel : FootballMatchModel! {
        didSet{
            guard matchModel != nil else { return }

            title.text = matchModel.matchDay + "共有" + "\(matchModel.playList.count)" + "场比赛可投"
    
            if matchModel.isSpreading == true {
                spreadBut.setImage(UIImage(named: "Unfold"), for: .normal)
            }else {
                spreadBut.setImage(UIImage(named: "Collapse"), for: .normal)
            }
        }
    }
    
//    public var headerType: FootballHeaderType = .match {
//        didSet{
//
//            switch headerType {
//            case .hotMatch:
//                title.textColor = ColorE85504
//                icon.isHidden = false
////                icon.snp.makeConstraints { (make) in
////                    make.centerY.equalTo(bgView.snp.centerY)
////                    make.left.equalTo(leftSpacing)
////                    make.width.height.equalTo(20)
////                }
////                title.snp.updateConstraints { (make) in
////                    make.top.bottom.equalTo(0)
////                    make.left.equalTo(icon.snp.right).offset(10)
////                    make.right.equalTo(spreadBut.snp.left).offset(-10)
////                }
//            case .match:
//                title.textColor = Color9F9F9F
//                icon.isHidden = true
////                title.snp.makeConstraints { (make) in
////                    make.top.bottom.equalTo(0)
////                    make.left.equalTo(leftSpacing)
////                    make.right.equalTo(spreadBut.snp.left).offset(-10)
////                }
//            }
//        }
//    }
    public var delegate : FootballSectionHeaderDelegate!
    
    
    //private var icon : UIImageView!
    private var title : UILabel!
    private var spreadBut : UIButton!
    private var bgView: UIView!
    
    private var line : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(5 * defaultScale)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-1.5)
        }
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(-0.5)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(0.6)
        }
        
//        icon.snp.makeConstraints { (make) in
//            make.centerY.equalTo(bgView.snp.centerY)
//            make.left.equalTo(leftSpacing)
//            make.width.height.equalTo(20)
//        }
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(spreadBut.snp.left).offset(-10)
        }
        spreadBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.right.equalTo(-rightSpacing)
            make.width.height.equalTo(20)
        }
    }
    private func initSubview() {
        self.contentView.backgroundColor = ColorF4F4F4
        
        line = UIView()
        line.backgroundColor = ColorEAEAEA
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        //icon = UIImageView()
        //icon.image = UIImage(named: "Popular")
        
        title = UILabel()
        title.font = Font13
        title.textAlignment = .left
        title.textColor = Color787878
        title.text = "热门比赛"
        
        spreadBut = UIButton(type: .custom)
        spreadBut.setImage(UIImage(named: "Unfold"), for: .normal)
        spreadBut.addTarget(self, action: #selector(spreadClicked(_:)), for: .touchUpInside)
        spreadBut.isSelected = true
        
        
        //bgView.addSubview(icon)
        bgView.addSubview(title)
        bgView.addSubview(spreadBut)
        self.contentView.addSubview(line)
        self.contentView.addSubview(bgView)
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
