//
//  FootballBottomView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballBottomView: UIView {

    private var titleLB: UILabel!
    private var deleteBut: UIButton!
    private var confirmBut: UIButton!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.text = "您共选择3场非单关比赛"
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "empty"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        
        
        self.addSubview(titleLB)
    }
    
    @objc private func deleteClicked(_ sender: UIButton) {
        
    }
    @objc private func confirmClicked(_ sender: UIButton) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
