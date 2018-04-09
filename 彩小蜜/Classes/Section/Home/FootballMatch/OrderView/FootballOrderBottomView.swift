//
//  FootballOrderBottomView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballOrderBottomViewDelegate {
    /// 确认
    func orderConfirm(filterList: [FootballPlayFilterModel], times: String) -> Void
    /// 串关选择
    func orderPlay(filterList: [FootballPlayFilterModel]) -> Void
    /// 倍数选择
    func orderMultiple() -> Void
}

class FootballOrderBottomView: UIView {

    public var filterList: [FootballPlayFilterModel]! {
        didSet{
            guard filterList != nil else { return }
            guard filterList.isEmpty == false else { return }
            var str : String = ""
            for filter in filterList {
                if filter.isSelected == true {
                    str += filter.title + ","
                }
            }
            str.removeLast()
            playBut.setTitle(filterList[0].playTitle + str, for: .normal)
        }
    }
    
    public var times : String! {
        didSet{
            multipleBut.setTitle("倍数  " + times + "倍", for: .normal)
        }
    }
    
    public var betInfo : FootballBetInfoModel! {
        didSet{
            guard let betNum = betInfo.betNum else { return }
            guard let times = betInfo.times else { return }
            guard let money = betInfo.money else { return }
            guard let minBonus = betInfo.minBonus else { return }
            guard let maxBouns = betInfo.maxBonus else { return }
            
            let moneyAtt = NSMutableAttributedString(string: "\(betNum)注 \(times)倍 共需：")
            let moneyStr = NSAttributedString(string: "¥\(money)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            moneyAtt.append(moneyStr)
            
            let bonusAtt = NSMutableAttributedString(string: "预测奖金: ")
            let bonusStr = NSAttributedString(string: "\(minBonus)-\(maxBouns)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            bonusAtt.append(bonusStr)
            
            moneyLB.attributedText = moneyAtt
            bonusLB.attributedText = bonusAtt
        }
    }
    
    public var delegate : FootballOrderBottomViewDelegate!
    
    private var titleLB: UILabel!
    private var playBut: UIButton!
    private var multipleBut: UIButton!
    
    private var playCornerIcon: UIImageView!
    private var multCornerIcon: UIImageView!
    
    private var topLine : UIView!
    private var hLineOne: UIView!
    private var hLineTwo: UIView!
    private var vLine : UIView!
    
    private var moneyLB: UILabel!
    private var bonusLB: UILabel!
    
    private var confirmBut: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: (32 + 3 + 88) * defaultScale  + CGFloat(SafeAreaBottomHeight)))
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(32 * defaultScale)
        }
        hLineOne.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        vLine.snp.makeConstraints { (make) in
            make.top.equalTo(hLineOne.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(hLineOne.snp.height)
            make.height.equalTo(44 * defaultScale)
        }
        hLineTwo.snp.makeConstraints { (make) in
            make.top.equalTo(vLine.snp.bottom)
            make.left.right.height.equalTo(hLineOne)
        }
        playBut.snp.makeConstraints { (make) in
            make.top.equalTo(hLineOne.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(vLine.snp.left)
            make.bottom.equalTo(hLineTwo.snp.top)
        }
        multipleBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(playBut)
            make.left.equalTo(vLine.snp.right)
            make.right.equalTo(0)
        }
        playCornerIcon.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.height.equalTo(10 * defaultScale)
        }
        multCornerIcon.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.height.equalTo(playCornerIcon)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(hLineTwo.snp.bottom)
            make.bottom.equalTo(confirmBut.snp.centerY)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(confirmBut.snp.left)
        }
        bonusLB.snp.makeConstraints { (make) in
            make.top.equalTo(confirmBut.snp.centerY)
            make.left.right.equalTo(moneyLB)
            make.bottom.equalTo(confirmBut)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.equalTo(hLineTwo.snp.bottom)
            make.right.equalTo(0)
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.width.equalTo(120 * defaultScale)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font10
        titleLB.textColor = Color9F9F9F
        titleLB.textAlignment = .center
        titleLB.text = "页面盘口，赔率仅供参考，请以出票盘口赔率为准"
        
        topLine = UIView()
        topLine.backgroundColor = ColorE9E9E9
        
        hLineOne = UIView()
        hLineOne.backgroundColor = ColorE9E9E9
        hLineTwo = UIView()
        hLineTwo.backgroundColor = ColorE9E9E9
        vLine = UIView()
        vLine.backgroundColor = ColorE9E9E9
        
        playBut = UIButton(type: .custom)
        //playBut.setTitle("串关  4串1", for: .normal)
        playBut.setTitleColor(Color505050, for: .normal)
        
        //playBut.titleLabel?.lineBreakMode = .byCharWrapping
        playBut.titleLabel?.lineBreakMode = .byTruncatingTail
        playBut.titleLabel?.numberOfLines = 2
        playBut.titleLabel?.font = Font12
        playBut.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)
        
        multipleBut = UIButton(type: .custom)
        multipleBut.titleLabel?.font = Font12
        multipleBut.setTitle("倍数  5倍", for: .normal)
        multipleBut.setTitleColor(Color505050, for: .normal)
        multipleBut.addTarget(self, action: #selector(multipleClicked(_:)), for: .touchUpInside)
        
        playCornerIcon = UIImageView()
        playCornerIcon.image = UIImage(named: "Clickable")
        
        multCornerIcon = UIImageView()
        multCornerIcon.image = UIImage(named: "Clickable")
        
        moneyLB = UILabel()
        moneyLB.font = Font11
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        moneyLB.text = "4注5倍 共需： ¥20"
        
        bonusLB = UILabel()
        bonusLB.font = Font11
        bonusLB.textColor = Color787878
        bonusLB.textAlignment = .left
        bonusLB.text = "预测奖金： 30.06-42.56元"
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        playBut.addSubview(playCornerIcon)
        multipleBut.addSubview(multCornerIcon)
        self.addSubview(titleLB)
        self.addSubview(hLineOne)
        self.addSubview(hLineTwo)
        self.addSubview(vLine)
        self.addSubview(playBut)
        self.addSubview(multipleBut)
        self.addSubview(moneyLB)
        self.addSubview(bonusLB)
        self.addSubview(confirmBut)
        self.addSubview(topLine)
    }
    
    @objc private func playClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderPlay(filterList: filterList)
    }
    @objc private func multipleClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderMultiple()
    }
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderConfirm(filterList: filterList, times: times)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
