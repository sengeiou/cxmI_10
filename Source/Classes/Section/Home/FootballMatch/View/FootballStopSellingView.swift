//
//  FootballStopSellingView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballStopSellingViewDelegate {
    func didTipDetails(view : UIView) -> Void
}

class FootballStopSellingView: UIView {

    public var delegate : FootballStopSellingViewDelegate!
    
    public var vertical: Bool = true {
        didSet{
            if vertical {
                layoutByVertical()
            }else {
                layoutByHorizontal()
            }
        }
    }
    private var titleLabel: UILabel!
    private var button : UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    @objc private func buttonClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDetails(view: self)
    }
    
    private func layoutByVertical() {
        titleLabel.textAlignment = .center
        button.contentHorizontalAlignment = .center
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY).offset(-2)
            make.height.equalTo(20)
            make.left.right.equalTo(0)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(2)
            make.left.right.height.equalTo(titleLabel)
        }
    }
    
    private func layoutByHorizontal() {
        titleLabel.textAlignment = .right
        button.contentHorizontalAlignment = .left
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(button)
        }
        button.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLabel)
            make.right.equalTo(0)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
    }
    
    private func initSubview() {
        
        self.backgroundColor = UIColor(hexColor: "C7C7C7", alpha: 0.2)
        
        titleLabel = UILabel()
        titleLabel.font = Font14
        titleLabel.textColor = Color505050
        titleLabel.textAlignment = .center
        titleLabel.text = "本场停售"
        
        button = UIButton(type: .custom)
        button.setTitle("详情>>", for: .normal)
        button.titleLabel?.font = Font14
        button.setTitleColor(Color505050, for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
