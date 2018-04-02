//
//  FootballFilterTopView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballFilterTopViewDelegate {
    /// 全选
    func allSelected() -> Void
    /// 反选
    func reverseSelected() -> Void
    /// 仅五大联赛
    func fiveSelected() -> Void
}

class FootballFilterTopView: UIView {

    public var delegate: FootballFilterTopViewDelegate!
    
    private var allBut: UIButton!
    private var reverseBut: UIButton!
    private var fiveBut: UIButton!
    
    private var vLineOne: UIView!
    private var vLineTwo: UIView!
    
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reverseBut.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.bottom.equalTo(0)
        }
        allBut.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(vLineOne.snp.left)
            make.width.equalTo(reverseBut)
        }
        fiveBut.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(vLineTwo.snp.right)
            make.width.equalTo(reverseBut)
        }
        vLineOne.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(0.3)
            make.right.equalTo(reverseBut.snp.left)
        }
        vLineTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(vLineOne)
            make.left.equalTo(reverseBut.snp.right)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        vLineOne = UIView()
        vLineOne.backgroundColor = ColorC8C8C8
        
        vLineTwo = UIView()
        vLineTwo.backgroundColor = ColorC8C8C8
        
        allBut = UIButton(type: .custom)
        allBut.setTitle("全选", for: .normal)
        allBut.setTitleColor(Color505050, for: .normal)
        allBut.addTarget(self, action: #selector(allClicked(_:)), for: .touchUpInside)
        
        reverseBut = UIButton(type: .custom)
        reverseBut.setTitle("反选", for: .normal)
        reverseBut.setTitleColor(Color505050, for: .normal)
        reverseBut.addTarget(self, action: #selector(reverseClicked(_:)), for: .touchUpInside)
        
        fiveBut = UIButton(type: .custom)
        fiveBut.setTitle("仅五大联赛", for: .normal)
        fiveBut.setTitleColor(Color505050, for: .normal)
        fiveBut.addTarget(self, action: #selector(fiveClicked(_:)), for: .touchUpInside)
        
        
        self.addSubview(vLineOne)
        self.addSubview(vLineTwo)
        self.addSubview(allBut)
        self.addSubview(reverseBut)
        self.addSubview(fiveBut)
    }
    
    @objc private func allClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.allSelected()
    }
    @objc private func reverseClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.reverseSelected()
    }
    @objc private func fiveClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.fiveSelected()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
