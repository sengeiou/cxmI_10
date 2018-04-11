//
//  FootballTotalView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballTotalViewDelegate: NSObjectProtocol {
    func totalSelected( view: FootballTotalView, teamInfo: FootballPlayListModel) -> Void
    func totalDeSelected( view: FootballTotalView, teamInfo: FootballPlayListModel) -> Void
    func totalSelectedItem() -> Void
}

class FootballTotalView: UIView {

   
    public var teamInfo : FootballPlayListModel! {
        didSet{
            guard teamInfo.matchPlays[0].matchCells.count == 8 else { return }
            
            guard let totalCellModels = teamInfo.matchPlays[0].matchCells else { return }
            
            let att0 = NSAttributedString(string: totalCellModels[0].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att1 = NSAttributedString(string: totalCellModels[1].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att2 = NSAttributedString(string: totalCellModels[2].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att3 = NSAttributedString(string: totalCellModels[3].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att4 = NSAttributedString(string: totalCellModels[4].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att5 = NSAttributedString(string: totalCellModels[5].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att6 = NSAttributedString(string: totalCellModels[6].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att7 = NSAttributedString(string: totalCellModels[7].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            
            title0.append(att0)
            title1.append(att1)
            title2.append(att2)
            title3.append(att3)
            title4.append(att4)
            title5.append(att5)
            title6.append(att6)
            title7.append(att7)
            
            button0.setAttributedTitle(title0, for: .normal)
            button1.setAttributedTitle(title1, for: .normal)
            button2.setAttributedTitle(title2, for: .normal)
            button3.setAttributedTitle(title3, for: .normal)
            button4.setAttributedTitle(title4, for: .normal)
            button5.setAttributedTitle(title5, for: .normal)
            button6.setAttributedTitle(title6, for: .normal)
            button7.setAttributedTitle(title7, for: .normal)
            
            setSelected(but: button0, isSelected: totalCellModels[0].isSelected)
            setSelected(but: button1, isSelected: totalCellModels[1].isSelected)
            setSelected(but: button2, isSelected: totalCellModels[2].isSelected)
            setSelected(but: button3, isSelected: totalCellModels[3].isSelected)
            setSelected(but: button4, isSelected: totalCellModels[4].isSelected)
            setSelected(but: button5, isSelected: totalCellModels[5].isSelected)
            setSelected(but: button6, isSelected: totalCellModels[6].isSelected)
            setSelected(but: button7, isSelected: totalCellModels[7].isSelected)
        }
    }
    
    public weak var delegate: FootballTotalViewDelegate!
    
    private let title0 = NSMutableAttributedString(string: "0 ")
    private let title1 = NSMutableAttributedString(string: "1 ")
    private let title2 = NSMutableAttributedString(string: "2 ")
    private let title3 = NSMutableAttributedString(string: "3 ")
    private let title4 = NSMutableAttributedString(string: "4 ")
    private let title5 = NSMutableAttributedString(string: "5 ")
    private let title6 = NSMutableAttributedString(string: "6 ")
    private let title7 = NSMutableAttributedString(string: "7+ ")
    
    private var centerLine : UIView!
    
    private var button0 : UIButton!
    private var button1 : UIButton!
    private var button2 : UIButton!
    private var button3 : UIButton!
    private var button4 : UIButton!
    private var button5 : UIButton!
    private var button6 : UIButton!
    private var button7 : UIButton!
    
    private var line1 : UIView!
    private var line2 : UIView!
    private var line3 : UIView!
    private var line4 : UIView!
    private var line5 : UIView!
    private var line6 : UIView!
    
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    public func backSelected() {
        setSelected(but: button0, isSelected: false)
        setSelected(but: button1, isSelected: false)
        setSelected(but: button2, isSelected: false)
        setSelected(but: button3, isSelected: false)
        setSelected(but: button4, isSelected: false)
        setSelected(but: button5, isSelected: false)
        setSelected(but: button6, isSelected: false)
        setSelected(but: button7, isSelected: false)
    }
    
    private func setSelected(but : UIButton, isSelected: Bool) {
        if isSelected == true {
            but.backgroundColor = ColorEA5504
            setButTitle(but: but, isSelected: true)
        }else {
            but.backgroundColor = ColorFFFFFF
            setButTitle(but: but, isSelected: false)
        }
         but.isSelected = isSelected
    }
    
    @objc private func buttonClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        
        setSelected(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        
        if sender.isSelected == true {
            delegate.totalSelected(view: self, teamInfo: teamInfo)
            teamInfo.matchPlays[0].matchCells[sender.tag].isSelected = true
        }else {
            teamInfo.matchPlays[0].matchCells[sender.tag].isSelected = false
            delegate.totalDeSelected(view: self, teamInfo: teamInfo)
        }
        
        delegate.totalSelectedItem()
    }
    
    private func setButTitle(but : UIButton, isSelected: Bool) {
        if isSelected == true {

            var titleAtt : NSMutableAttributedString!
            
            if but.tag == 7 {
                titleAtt = NSMutableAttributedString(string: "\(but.tag)+ ", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
            }else {
                titleAtt = NSMutableAttributedString(string: "\(but.tag) ", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
            }
            
            let att = NSAttributedString(string: teamInfo.matchPlays[0].matchCells[but.tag].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
            titleAtt.append(att)
            but.setAttributedTitle(titleAtt, for: .normal)
            
        }else {
            var titleAtt : NSMutableAttributedString!
            
            if but.tag == 7 {
                titleAtt = NSMutableAttributedString(string: "\(but.tag)+ ", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
            }else {
                titleAtt = NSMutableAttributedString(string: "\(but.tag) ", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
            }
            
            let att = NSAttributedString(string: teamInfo.matchPlays[0].matchCells[but.tag].cellOdds, attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            titleAtt.append(att)
            but.setAttributedTitle(titleAtt, for: .normal)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(0.4)
        }
        
        button0.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.bottom.equalTo(centerLine.snp.top)
        }
        button1.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button0)
            make.left.equalTo(button0.snp.right).offset(1)
        }
        button2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button0)
            make.left.equalTo(button1.snp.right).offset(1)
        }
        button3.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button0)
            make.left.equalTo(button2.snp.right).offset(1)
            make.right.equalTo(0)
        }
        button4.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.left.bottom.equalTo(0)
        }
        button5.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button4)
            make.left.equalTo(button4.snp.right).offset(1)
        }
        button6.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button4)
            make.left.equalTo(button5.snp.right).offset(1)
        }
        button7.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(button4)
            make.left.equalTo(button6.snp.right).offset(1)
            make.right.equalTo(0)
        }

        line1.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(button0.snp.right)
            make.width.equalTo(0.5)
            make.bottom.equalTo(centerLine.snp.top).offset(-5)
        }
        line2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.left.equalTo(button1.snp.right)
        }
        line3.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.left.equalTo(button2.snp.right)
        }
        line4.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(button4.snp.right)
            make.width.equalTo(line1)
        }
        line5.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line4)
            make.left.equalTo(button5.snp.right)
        }
        line6.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line4)
            make.left.equalTo(button6.snp.right)
        }
        
    }
    // MARK: 初始化子视图
    private func initSubview() {
        
        self.layer.borderWidth = 0.4
        self.layer.borderColor = Color9F9F9F.cgColor
        
        
        centerLine = UIView()
        centerLine.backgroundColor = Color9F9F9F
        
        button0 = getButton(tag: 0)
        button1 = getButton(tag: 1)
        button2 = getButton(tag: 2)
        button3 = getButton(tag: 3)
        button4 = getButton(tag: 4)
        button5 = getButton(tag: 5)
        button6 = getButton(tag: 6)
        button7 = getButton(tag: 7)
        
        line1 = getLine()
        line2 = getLine()
        line3 = getLine()
        line4 = getLine()
        line5 = getLine()
        line6 = getLine()
        
        
       
        
        self.addSubview(button0)
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(button3)
        self.addSubview(button4)
        self.addSubview(button5)
        self.addSubview(button6)
        self.addSubview(button7)
        
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(line3)
        self.addSubview(line4)
        self.addSubview(line5)
        self.addSubview(line6)
        
        self.addSubview(centerLine)
    }
    
    private func getButton(tag: Int) -> UIButton {
        let but = UIButton(type: .custom)
        but.tag = tag
        but.titleLabel?.font = Font10
        but.titleLabel?.textColor = Color505050
        but.setTitle("\(tag)", for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return but 
    }
    
    private func getLine() -> UIView {
        let view = UIView()
        view.backgroundColor = ColorC8C8C8
        
        return view
    }
    
   
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
