//
//  MeAboutViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MeAboutViewController: BaseViewController {

    
    
    // MARK: - 点击事件
    @objc private func complainClicked(_ sender: UIButton) {
        print("投诉建议")
        let complaint = MeComplaintVC()
        pushViewController(vc: complaint)
    }
    @objc private func guaranteeClicked(_ sender: UIButton) {
        print("安全保障")
        let guarantee = MeGuaranteeVC()
        pushViewController(vc: guarantee)
    }
    
    // MARK: - 属性
    private var versionLB : UILabel!     // 版本号
    private var complaintBut : UIButton! // 投诉建议
    private var guaranteeBut : UIButton! // 安全保障
    private var companyName : UILabel!   // 公司名
    private var serviceLB : UILabel!     // 客服
    private var website : UILabel!       // 官网
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·关于我们"
        initSubview()
    }
    
    
    // MARK: - 初始化
    private func initSubview() {
        self.view.backgroundColor = UIColor.cyan
        
        versionLB = UILabel()
        versionLB.text = "彩小秘  v1.0"
        versionLB.font = Font12
        versionLB.textAlignment = .center
        
        companyName = UILabel()
        companyName.text = "北京数字传奇网络技术有限公司"
        companyName.font = Font12
        companyName.textAlignment = .center
        
        serviceLB = UILabel()
        serviceLB.text = "客服热线： 400-000-1334"
        serviceLB.font = Font12
        serviceLB.textAlignment = .center
        
        website = UILabel()
        website.text = "官网: http:/www.caixiaomi.com"
        website.font = Font12
        website.textAlignment = .center
        
        complaintBut = UIButton(type: .custom)
        complaintBut.setTitle("投诉建议", for: .normal)
        complaintBut.setTitleColor(UIColor.black, for: .normal)
        complaintBut.contentHorizontalAlignment = .left
        complaintBut.backgroundColor = UIColor.white
        complaintBut.layer.cornerRadius = 5
        complaintBut.addTarget(self, action: #selector(complainClicked(_:)), for: .touchUpInside)
        
        guaranteeBut = UIButton(type: .custom)
        guaranteeBut.setTitle("安全保障", for: .normal)
        guaranteeBut.setTitleColor(UIColor.black, for: .normal)
        guaranteeBut.contentHorizontalAlignment = .left
        guaranteeBut.backgroundColor = UIColor.white
        guaranteeBut.layer.cornerRadius = 9
        guaranteeBut.addTarget(self, action: #selector(guaranteeClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(versionLB)
        self.view.addSubview(guaranteeBut)
        self.view.addSubview(complaintBut)
        self.view.addSubview(companyName)
        self.view.addSubview(serviceLB)
        self.view.addSubview(website)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        versionLB.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 30)
        }
        complaintBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(versionLB.snp.bottom).offset(60)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        guaranteeBut.snp.makeConstraints { (make) in
            make.height.equalTo(complaintBut)
            make.top.equalTo(complaintBut.snp.bottom).offset(1)
            make.left.right.equalTo(complaintBut)
        }
        companyName.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.bottom.equalTo(serviceLB.snp.top).offset(-10)
            make.left.right.equalTo(self.view)
        }
        serviceLB.snp.makeConstraints { (make) in
            make.height.equalTo(companyName)
            make.bottom.equalTo(website.snp.top).offset(-10)
            make.left.right.equalTo(companyName)
        }
        website.snp.makeConstraints { (make) in
            make.height.equalTo(serviceLB)
            make.bottom.equalTo(self.view).offset(-100)
            make.left.right.equalTo(serviceLB)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
