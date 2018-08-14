//
//  FootballFilterBottomView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


protocol FootballFilterBottomViewDelegate {
    func filterConfirm() -> Void
    func filterCancel() -> Void
}

class FootballFilterBottomView: UIView {

    public var delegate : FootballFilterBottomViewDelegate!
    
    private var line : UIView!
    private var vLine : UIView!
    
    private var confirmBut: UIButton!
    private var cancelBut: UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(0)
        }
        vLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(0.5)
            make.top.bottom.equalTo(0)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(0)
            make.right.equalTo(vLine.snp.left)
        }
        cancelBut.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.left.equalTo(vLine.snp.right)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        vLine = UIView()
        vLine.backgroundColor = ColorE9E9E9
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.titleLabel?.font = Font13
        confirmBut.setTitleColor(ColorEA5504, for: .normal)
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        cancelBut = UIButton(type: .custom)
        cancelBut.setTitle("取消", for: .normal)
        cancelBut.titleLabel?.font = Font13
        cancelBut.setTitleColor(Color505050, for: .normal)
        cancelBut.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
        
        self.addSubview(line)
        self.addSubview(vLine)
        self.addSubview(confirmBut)
        self.addSubview(cancelBut)
    }
    
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.filterConfirm()
    }
    @objc private func cancelClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.filterCancel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
