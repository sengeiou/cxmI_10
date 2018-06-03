//
//  ActivityRechargeResultVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol ActivityRechargeResultVCDelegate {
    func didTipShowDetail(vc: ActivityRechargeResultVC) -> Void
}

class ActivityRechargeResultVC: BasePopViewController {

    public var rechargeAmount : String! {
        didSet{
            guard rechargeAmount != nil else { return }
            let amountAtt = NSMutableAttributedString(string: "恭喜!\n", attributes: [NSAttributedStringKey.font: Font36, NSAttributedStringKey.foregroundColor : ColorF6AD41])
            let title = NSAttributedString(string: "彩小秘恭喜您通过充值活动\n", attributes: [NSAttributedStringKey.font: Font16, NSAttributedStringKey.foregroundColor : ColorFFFFFF])
            let amount = NSMutableAttributedString(string: "获得\(rechargeAmount!)元彩金", attributes: [NSAttributedStringKey.font: Font25, NSAttributedStringKey.foregroundColor : ColorF6AD41])
            amountAtt.append(title)
            amountAtt.append(amount)
            detailLb.attributedText = amountAtt
        }
    }
    public var payLogId : String! {
        didSet{
            guard payLogId != nil else { return }
            receiveRechargeBonusRequest()
        }
    }
    public var delegate : ActivityRechargeResultVCDelegate!
    
    private var icon : UIImageView!
    private var detailLb : UILabel!
    private var closeBut: UIButton!
    private var detailBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
        
    }

    // MARK: - 点击事件
    @objc private func closeClicked(_ sender : UIButton) {
        self.backPopVC()
    }
    @objc private func detailButClicked(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipShowDetail(vc: self)
    }
    
    // MARK: - 网络请求
    private func receiveRechargeBonusRequest() {
        guard self.payLogId != nil else { return }
        
        _ = activityProvider.rx.request(.receiveRechargeBonus(payLogId: self.payLogId))
            .asObservable()
            .mapObject(type: ReceiveRechargeBonusModel.self)
            .subscribe(onNext: { (data) in
                self.rechargeAmount = data.donationPrice
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                        
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                    
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
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
        
        closeBut = UIButton(type: .custom)
        closeBut.setTitle("关闭", for: .normal)
        closeBut.setTitleColor(ColorEA5504, for: .normal)
        closeBut.backgroundColor = ColorF6AD41
        closeBut.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
        
        detailBut = UIButton(type: .custom)
        detailBut.setTitle("去查看", for: .normal)
        detailBut.setTitleColor(ColorFFFFFF, for: .normal)
        detailBut.backgroundColor = ColorEA5504
        detailBut.addTarget(self, action: #selector(detailButClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(bagView)
        bagView.addSubview(icon)
        bagView.addSubview(detailLb)
        bagView.addSubview(closeBut)
        bagView.addSubview(detailBut)
        
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
            make.height.equalTo(100)
        }
        closeBut.snp.makeConstraints { (make) in
            make.top.equalTo(detailLb.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.right.equalTo(self.view.snp.centerX).offset(-10)
        }
        detailBut.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(closeBut)
            make.left.equalTo(self.view.snp.centerX).offset(10)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
