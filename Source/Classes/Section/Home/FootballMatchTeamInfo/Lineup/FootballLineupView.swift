//
//  FootballLineupView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    private func initSubview() {
        //self.alpha = 0
        
        let image = UIImageView(image: UIImage(named: "Hometeam_1"))
        
        self.addSubview(image)
        
        image.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalTo(self.snp.center)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
