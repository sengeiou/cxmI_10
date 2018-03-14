//
//  MeComplaintVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class MeComplaintVC: BaseViewController {

    
    // MARK: - 点击事件
    @objc private func sendClicked(_ sender: UIButton) {
        print("发送")
    }
    
    // MARK: - 属性
    private var titleLB : UILabel!
    private var sendBut : UIButton! // 发送
    private var textView : UITextView! // 投诉输入
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·投诉建议"
        initSubview()
    }

    private func initSubview() {
        self.view.backgroundColor = UIColor.gray
        
        titleLB = UILabel()
        titleLB.font = Font12
        titleLB.textColor = UIColor.black
        titleLB.numberOfLines = 5
        titleLB.text = """
        尊敬的上帝您好：
        请将您对我们产品的反馈内容输入下面输入框中，
        我们会认真对待您的每一条建议。谢谢您的反馈。
        如果您有在使用上不清楚的地方，请点击右上角
        联系人工客服进行咨询。
        """
        
        textView = UITextView()
        textView.backgroundColor = UIColor.white
        
        sendBut = UIButton(type: .custom)
        sendBut.setTitle("发送", for: .normal)
        sendBut.setTitleColor(UIColor.white, for: .normal)
        sendBut.backgroundColor = UIColor.blue
        sendBut.layer.cornerRadius = 5
        sendBut.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(titleLB)
        self.view.addSubview(sendBut)
        self.view.addSubview(textView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLB.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.right.equalTo(titleLB)
            make.top.equalTo(titleLB.snp.bottom).offset(10)
        }
        sendBut.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(textView.snp.bottom).offset(100)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
