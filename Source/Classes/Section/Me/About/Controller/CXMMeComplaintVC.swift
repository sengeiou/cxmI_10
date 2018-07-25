//
//  MeComplaintVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//  投诉建议

import UIKit


class CXMMeComplaintVC: BaseViewController {

    
    // MARK: - 点击事件
    @objc private func sendClicked(_ sender: UIButton) {
        self.textView.textView.resignFirstResponder()
        print("发送")
        guard self.textView.textView.text != nil, self.textView.textView.isEmpty == false else {
            showHUD(message: "请输入您的宝贵意见")
            return
        }
        complainRequest()
        TongJi.log(.投诉建议发送, label: "投诉建议发送")
    }
    
    // MARK: - 属性
    private var titleLB : UILabel!
    private var sendBut : UIButton! // 发送
    private var textView : HXTextView! // 投诉输入
    private var bgView: UIView!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 投诉建议"
        initSubview()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("投诉建议页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("投诉建议页")
    }
    // MARK: = 网络请求
    private func complainRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        guard let text = self.textView.textView.text else { return }
        _ = userProvider.rx.request(.complain(content: text))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.showHUD(message: data.msg)
                self.popViewController()
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        
                        self.showHUD(message: msg!)
                    }
                    print("\(code)   \(msg!)")
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    
    private func initSubview() {
        self.view.backgroundColor = ColorF4F4F4
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.numberOfLines = 5
        titleLB.text = """
        尊敬的上帝您好：
            请将您对我们产品的反馈内容输入下面输入框中，我们会认真对待您的每一条建议。谢谢您的反馈。
        """
        
        textView = HXTextView()
        textView.limitNumber = 140
        
        sendBut = UIButton(type: .custom)
        sendBut.setTitle("发送", for: .normal)
        sendBut.setTitleColor(ColorFFFFFF, for: .normal)
        sendBut.backgroundColor = ColorEA5504
        sendBut.layer.cornerRadius = 5
        sendBut.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(bgView)
        self.view.addSubview(sendBut)
        bgView.addSubview(titleLB)
        bgView.addSubview(textView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(245 * defaultScale)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.height.equalTo(100 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.top.equalTo(bgView).offset(1)
        }
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(120 * defaultScale)
            make.left.right.equalTo(titleLB)
            make.top.equalTo(titleLB.snp.bottom).offset(10)
        }
        sendBut.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(bgView.snp.bottom).offset(loginButTopSpacing)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.textView.resignFirstResponder()
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.投诉建议返回, label: "投诉建议返回")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
