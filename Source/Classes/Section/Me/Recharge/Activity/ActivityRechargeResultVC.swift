//
//  ActivityRechargeResultVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ActivityRechargeResultVC: BasePopViewController {

    public var rechargeAmount : String! {
        didSet{
            let amountAtt = NSMutableAttributedString(string: "恭喜!\n", attributes: [NSAttributedStringKey.font: Font36, NSAttributedStringKey.foregroundColor : ColorF6AD41])
            let title = NSAttributedString(string: "彩小秘恭喜您通过充值活动\n", attributes: [NSAttributedStringKey.font: Font16, NSAttributedStringKey.foregroundColor : ColorFFFFFF])
            let amount = NSMutableAttributedString(string: "获得\(rechargeAmount!)元彩金", attributes: [NSAttributedStringKey.font: Font36, NSAttributedStringKey.foregroundColor : ColorF6AD41])
            amountAtt.append(title)
            amountAtt.append(amount)
            detailLb.attributedText = amountAtt
        }
    }
    
    private var icon : UIImageView!
    private var detailLb : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
       
    }

    private func initSubview() {
        
        let bagView = UIView()
        bagView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        icon = UIImageView()
        icon.image = UIImage(named: "activityRecharge")
        
        detailLb = UILabel()
        detailLb.numberOfLines = 0
        detailLb.textAlignment = .center
        detailLb.font = Font14
        
        self.view.addSubview(bagView)
        bagView.addSubview(icon)
        bagView.addSubview(detailLb)
        
        bagView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        icon.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.centerY)
            make.height.width.equalTo(188)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        detailLb.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
