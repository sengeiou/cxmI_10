//
//  LeagueDetailPagerHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueDetailPagerHeaderDelegate {
    func didSelectHeaderPagerItem(style : LeagueDetailStyle) -> Void
}

class LeagueDetailPagerHeader: UITableViewHeaderFooterView {

    static let identifier : String = "LeagueDetailPagerHeader"
    
    public var delegate : LeagueDetailPagerHeaderDelegate!
    
    private var scoreButton : UIButton!
    private var shooterButton : UIButton!
    private var matchButton : UIButton!
    private var teamButton : UIButton!
    
    private var proline : UIView!
    
    private var bgView : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorF4F4F4
        initSubview()
    }
    
    private func initSubview() {
        scoreButton = getButton(name: "积分榜")
        shooterButton = getButton(name: "射手榜")
        matchButton = getButton(name: "赛程安排")
        teamButton = getButton(name: "球队资料")
        
        scoreButton.tag = 100
        shooterButton.tag = 200
        matchButton.tag = 300
        teamButton.tag = 400
        
        
        proline = UIView()
        proline.backgroundColor = ColorEA5504
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        //self.contentView.addSubview(scoreButton)
        self.contentView.addSubview(shooterButton)
        self.contentView.addSubview(matchButton)
        self.contentView.addSubview(teamButton)
        self.contentView.addSubview(proline)
        self.contentView.addSubview(bgView)
        
        scoreButton.snp.makeConstraints { (make) in
            
        }
        
        shooterButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY).offset(-5)
            make.height.equalTo(30)
            make.left.equalTo(16)
        }
        matchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(shooterButton)
            make.left.equalTo(shooterButton.snp.right).offset(10)
            make.width.height.equalTo(shooterButton)
        }
        teamButton.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(shooterButton)
            make.left.equalTo(matchButton.snp.right).offset(10)
            make.right.equalTo(-16)
        }
        proline.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(1)
            make.centerX.equalTo(shooterButton.snp.centerX)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
    }
    
    private func getButton (name : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(name, for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.setTitleColor(ColorEA5504, for: .selected)
        but.titleLabel?.font = Font12
        but.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return but
    }
    
    @objc private func buttonClick(_ sender : UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.changeProView(sender)
        }
        
        changeButtonColor(sender)
        
        guard delegate != nil else { return }
        
        switch sender.tag {
        case 100:
            delegate.didSelectHeaderPagerItem(style: .积分榜)
        case 200:
            delegate.didSelectHeaderPagerItem(style: .射手榜)
        case 300:
            delegate.didSelectHeaderPagerItem(style: .赛程安排)
        case 400:
            delegate.didSelectHeaderPagerItem(style: .球队资料)
        default: break
            
        }
    }
    
    private func changeProView(_ sender : UIButton) {
        self.proline.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(1)
            make.centerX.equalTo(sender.snp.centerX)
        }
        self.contentView.layoutIfNeeded()
    }
    
    private func changeButtonColor(_ sender : UIButton) {
        scoreButton.isSelected = false
        shooterButton.isSelected = false
        matchButton.isSelected = false
        teamButton.isSelected = false
        
        sender.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LeagueDetailPagerHeader {
    public func configure(with style : LeagueDetailStyle) {
        switch style {
        case .积分榜:
            break
        case .射手榜:
            changeButtonColor(self.shooterButton)
            changeProView(self.shooterButton)
        case .赛程安排:
            changeProView(self.matchButton)
            changeButtonColor(self.matchButton)
        case .球队资料:
            changeProView(self.teamButton)
            changeButtonColor(self.teamButton)
       
        }
    }
}
