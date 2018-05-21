//
//  MeGuaranteeVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MeGuaranteeVC: BaseViewController {
    // MARK: - 点击事件
    
    // MARK: - 属性
    private var guaranteeLB : UILabel!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initSubview()
    }

    private func initSubview() {
        guaranteeLB = UILabel()
        guaranteeLB.font = Font22
        guaranteeLB.numberOfLines = 0
        guaranteeLB.textColor = UIColor.black
        //guaranteeLB.textAlignment = .justified
        guaranteeLB.text = """
        资金安全
            专业安全团队
            银行级安全技术保障
            数据安全：
              安全工程师7*24小时保障服务安全运转
            隐私保障：
              数据库加密，全方位监测；
            信息安全：
              采用软，硬件防护，有效防止病毒和恶意入侵
        购彩保障
            购彩方案由实体店真实出票
            可联系客服索要实体票
        """
        
        self.view.addSubview(guaranteeLB)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guaranteeLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
            make.left.bottom.right.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
