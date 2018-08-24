//
//  ActivityRechargeCouponVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol ActivityRechargeCouponVCDelegate {
    func didTipReceive(vc: CXMActivityRechargeCouponVC, amount : String) -> Void
}

class CXMActivityRechargeCouponVC: BasePopViewController {

    public var rechargeAmount : String!
    public var payLogId : String!
    public var delegate : ActivityRechargeCouponVCDelegate!
    
    private var couponView : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
    }

    // MARK: - 点击事件
    @objc private func receive(_ sender : UIButton) {
        guard delegate != nil else { return }
        guard self.rechargeAmount != nil else { return }
        delegate.didTipReceive(vc: self, amount: self.rechargeAmount)
    }
    
    private func initSubview() {
        self.viewHeight = 280
        
        couponView = UIButton(type: .custom)
        couponView.setBackgroundImage(UIImage(named: "activityBonus"), for: .normal)
        couponView.addTarget(self, action: #selector(receive(_:)), for: .touchUpInside)
        
        
        self.pushBgView.backgroundColor = UIColor.clear
        self.pushBgView.addSubview(couponView)
        
        couponView.snp.makeConstraints { (make) in
            make.center.equalTo(self.pushBgView.snp.center)
            make.height.width.equalTo(280)
        }
        
    }
    
    override func backPopVC() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
