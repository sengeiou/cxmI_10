//
//  CXMMFootballMatchMenu.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMFootballMatchMenu: BasePopViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromTop
        initSubview()
    }

    private func initSubview() {
        self.viewHeight = 300
        
        let spfBut = UIButton(type: .custom)
        
        spfBut.setTitle("胜平负", for: .normal)
        spfBut.setTitleColor(Color505050, for: .normal)
        
        self.pushBgView.addSubview(spfBut)
        
        spfBut.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
    }
    


}
