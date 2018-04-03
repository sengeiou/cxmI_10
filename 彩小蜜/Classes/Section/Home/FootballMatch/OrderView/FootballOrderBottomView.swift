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
    func orderConfirm() -> Void
    /// 串关选择
    func orderPlay() -> Void
    /// 倍数选择
    func orderMultiple() -> Void
}

class FootballOrderBottomView: UIView {

    public var delegate : FootballOrderBottomViewDelegate!
    
    private var titleLB: UILabel!
    private var playBut: UIButton!
    private var multipleBut: UIButton!
    
    private var playCornerIcon: UIImageView!
    private var multCornerIcon: UIImageView!
    
    private var hLineOne: UIView!
    private var hLineTwo: UIView!
    private var vLine : UIView!
    
    private var moneyLB: UILabel!
    private var bonusLB: UILabel!
    
    private var confirmBut: UIButton!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(120 * defaultScale) + CGFloat(SafeAreaBottomHeight)))
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
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
            make.width.height.equalTo(8)
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
            make.width.equalTo(90)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font12
        titleLB.textColor = ColorC8C8C8
        titleLB.textAlignment = .center
        titleLB.text = "页面盘口，赔率仅供参考，请以出票盘口赔率为准"
        
        hLineOne = UIView()
        hLineOne.backgroundColor = ColorF4F4F4
        hLineTwo = UIView()
        hLineTwo.backgroundColor = ColorF4F4F4
        vLine = UIView()
        vLine.backgroundColor = ColorF4F4F4
        
        playBut = UIButton(type: .custom)
        playBut.setTitle("串关  4串1", for: .normal)
        playBut.setTitleColor(Color505050, for: .normal)
        playBut.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)
        
        multipleBut = UIButton(type: .custom)
        multipleBut.setTitle("倍数  5倍", for: .normal)
        multipleBut.setTitleColor(Color505050, for: .normal)
        multipleBut.addTarget(self, action: #selector(multipleClicked(_:)), for: .touchUpInside)
        
        playCornerIcon = UIImageView()
        playCornerIcon.image = UIImage(named: "Expired")
        
        multCornerIcon = UIImageView()
        multCornerIcon.image = UIImage(named: "Expired")
        
        moneyLB = UILabel()
        moneyLB.font = Font14
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        moneyLB.text = "4注5倍 共需： ¥20"
        
        bonusLB = UILabel()
        bonusLB.font = Font14
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
    }
    
    @objc private func playClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderPlay()
    }
    @objc private func multipleClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderMultiple()
    }
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.orderConfirm()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
