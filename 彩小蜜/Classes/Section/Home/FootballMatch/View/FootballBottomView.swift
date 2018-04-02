//
//  FootballBottomView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballBottomViewDelegate {
    func delete() -> Void
    func confirm() -> Void
}

class FootballBottomView: UIView {

    public var delegate: FootballBottomViewDelegate!
    
    private var titleLB: UILabel!
    private var deleteBut: UIButton!
    private var confirmBut: UIButton!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(44 * defaultScale) + CGFloat(SafeAreaBottomHeight)))
        print(SafeAreaBottomHeight)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(44 * defaultScale)
            make.left.equalTo(deleteBut.snp.right).offset(leftSpacing)
            make.right.equalTo(confirmBut.snp.left)
        }
        
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLB.snp.centerY)
            make.height.width.equalTo(30)
            make.left.equalTo(leftSpacing)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(0)
            make.width.equalTo(100)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.text = "您共选择0场非单关比赛"
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "empty"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.addSubview(titleLB)
        self.addSubview(deleteBut)
        self.addSubview(confirmBut)
    }
    
    @objc private func deleteClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.delete()
    }
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.confirm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
