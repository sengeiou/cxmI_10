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

    public var number : Int! {
        didSet{
            guard number != 0 else {
            titleLB.text = "请至少选择1场单关比赛或者2场非单关比赛"
                return }
            
            titleLB.text = "您共选择\(number!)场非单关比赛"
        }
    }
    
    public var delegate: FootballBottomViewDelegate!
    
    private var titleLB: UILabel!
    private var deleteBut: UIButton!
    private var confirmBut: UIButton!
    
    private var line : UIView!
    
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
            make.left.equalTo(line.snp.right).offset(leftSpacing)
            make.right.equalTo(confirmBut.snp.left)
        }
        
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLB.snp.centerY)
            make.height.width.equalTo(20)
            make.left.equalTo(14 * defaultScale)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(0.3)
            make.left.equalTo(deleteBut.snp.right).offset(leftSpacing)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(0)
            make.width.equalTo(120 * defaultScale)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorC8C8C8
        
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.numberOfLines = 2
        titleLB.text = "请至少选择1场单关比赛或者2场非单关比赛"
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "trashbin"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.addSubview(line)
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
