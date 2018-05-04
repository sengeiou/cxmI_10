//
//  BottomView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol BottomViewDelegate {
    func didTipConfitm() -> Void
    func didTipCancel() -> Void
}

class BottomView: UIView {

    public var confirmTitle : String! {
        didSet{
            guard confirmTitle != nil else { return }
            confirmBut.setTitle(confirmTitle, for: .normal)
        }
    }
    
    public var delegate : BottomViewDelegate!
    
    private var bottomLine : UIView!
    private var vLine : UIView!
    private var confirmBut: UIButton!
    private var cancelBut : UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(1)
            make.left.right.equalTo(0)
        }
        
        vLine.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(1)
            make.centerX.equalTo(self.snp.centerX)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(vLine.snp.left)
        }
        cancelBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(confirmBut)
            make.left.equalTo(vLine.snp.right)
            make.right.equalTo(0)
        }
    }
    private func initSubview() {
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        vLine = UIView()
        vLine.backgroundColor = ColorC8C8C8
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.titleLabel?.font = Font14
        confirmBut.setTitleColor(ColorEA5504, for: .normal)
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        cancelBut = UIButton(type: .custom)
        cancelBut.setTitle("取消", for: .normal)
        cancelBut.titleLabel?.font = Font14
        cancelBut.setTitleColor(Color505050, for: .normal)
        cancelBut.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
        
        self.addSubview(bottomLine)
        self.addSubview(vLine)
        self.addSubview(confirmBut)
        self.addSubview(cancelBut)
    }
    
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipConfitm()
    }
    @objc private func cancelClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipCancel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
