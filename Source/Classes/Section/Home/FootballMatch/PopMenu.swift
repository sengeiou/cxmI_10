//
//  PopMenu.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PopMenu: UIView {

    var viewHeight : CGFloat = 100
    
    public var popView: UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.alpha = 0
        initSubview()
    }
    
    private func initSubview() {
        popView = UIView()
        popView.backgroundColor = ColorFFFFFF
        self.backgroundColor = UIColor(hexColor: "EA5504", alpha: 0.5)
        self.addSubview(popView)
        layoutPopView()
    }
    
    private func layoutPopView() {
        popView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopMenu {
    public func show() {
        UIView.animate(withDuration: 0.5, animations: {
            self.popView.snp.updateConstraints({ (make) in
                make.height.equalTo(self.viewHeight)
            })
            self.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    public func hide() {
        self.alpha = 0
        self.popView.snp.updateConstraints({ (make) in
            make.height.equalTo(0)
        })
    }
}

extension PopMenu {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }
}
