//
//  FootballTimesFilter.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//  倍数筛选

import UIKit

fileprivate let TimesViewHeight : CGFloat = 36 * defaultScale

protocol FootballTimesFilterVCDelegate {
    func timesConfirm(times: String) -> Void
}

class FootballTimesFilterVC: BasePopViewController, UITextFieldDelegate, CXMKeyboardViewDelegate {
    
    public var delegate : FootballTimesFilterVCDelegate!

    public var times : String! {
        didSet{
            self.textField.text = times
        }
    }
    
    private var keyboardView: CXMKeyboardView!
    private var backBut: UIButton!
    private var timesTitle: UILabel!
    private var textField : UITextField!
    private var timesView: UIView!
    
    private var isFirst: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboardView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(KeyboardHeight)
        }
        timesView.snp.makeConstraints { (make) in
            make.bottom.equalTo(keyboardView.snp.top)
            make.left.right.equalTo(0)
            make.height.equalTo(TimesViewHeight)
        }
        
        backBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(timesTitle.snp.centerY)
            make.width.height.equalTo(12 * defaultScale)
            make.left.equalTo(leftSpacing)
        }
        timesTitle.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(timesView.snp.top)
            make.right.equalTo(textField.snp.left).offset(-10)
        }
        textField.snp.makeConstraints { (make) in
            make.centerY.equalTo(timesTitle.snp.centerY)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(30 * defaultScale)
            make.width.equalTo(76 * defaultScale)
        }
    }
    
    private func initSubview() {
        self.viewHeight = 242 * defaultScale
        
        keyboardView = CXMKeyboardView()
        keyboardView.delegate = self
        
        backBut = UIButton(type: .custom)
        backBut.setBackgroundImage(UIImage(named: "Collapse"), for: .normal)
        backBut.addTarget(self, action: #selector(backClicked(_:)), for: .touchUpInside)
        
        timesTitle = UILabel()
        timesTitle.font = Font14
        timesTitle.textColor = Color505050
        timesTitle.textAlignment = .right
        timesTitle.sizeToFit()
        timesTitle.text = "倍数"
        
        textField = UITextField()
        textField.text = "5"
        textField.delegate = self
        textField.textColor = Color505050
        textField.layer.borderWidth = 0.3
        textField.textAlignment = .center
        textField.layer.borderColor = ColorC8C8C8.cgColor
        
        timesView = UIView()
        timesView.backgroundColor = ColorFFFFFF
        
        self.pushBgView.addSubview(timesTitle)
        self.pushBgView.addSubview(textField)
        self.pushBgView.addSubview(timesView)
        self.pushBgView.addSubview(backBut)
        self.pushBgView.addSubview(keyboardView)
        initTiemsView()
    }
    
    private func initTiemsView() {
        let width: CGFloat = screenWidth/5
        let titleList = ["5","10","20","50","100"]
        for index in 0...4 {
            let item = getTimesItem()
            item.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: TimesViewHeight)
            timesView.addSubview(item)
            let number = titleList[index]
            item.setTitle(number + "倍", for: .normal)
            item.tag = Int(number)!
        }
    }
    
    private func getTimesItem() -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitleColor(Color505050, for: .normal)
        but.layer.borderWidth = 0.3
        but.titleLabel?.font = Font14
        but.layer.borderColor = ColorC8C8C8.cgColor
        but.addTarget(self, action: #selector(timesClicked(_:)), for: .touchUpInside)
        return but
    }
    
    // MARK: - 键盘  Delegate
    func keyboardDidTipItem(num: String) {
        
        //guard let number = Int(self.textField.text!) else { return }
        
        guard (self.textField.text?.count)! <= 4 else { return }
//        guard number < 10000 else {
//            self.textField.text = "99999"
//            return }
        
        if isFirst == true {
            textField.text = nil
            isFirst = false
        }
        
        if self.textField.text == nil || self.textField.text == "" {
            if num == "0" {
                self.textField.text = "1"
            }else {
                self.textField.text = self.textField.text! + num
            }
        }else {
            self.textField.text = self.textField.text! + num
        }
        
    }
    // 删除
    func keyboardDelete() {
        guard textField.text != nil else { return }
//        guard textField.text?.lengthOfBytes(using: .utf8) != 1 else {
//            self.textField.text = "1"
//            return
//        }
        guard textField.text != "" else { return }
        self.textField.text?.removeLast()
    }
    // 确定
    func keyboardConfirm() {
        guard delegate != nil else { return }
        guard var times = self.textField.text else { return }
        if self.textField.text == nil || self.textField.text == "" {
            self.times = "1"
            times = "1"
        }
        delegate.timesConfirm(times: times)
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    // MARK: - 点击事件
    // 选取倍数
    @objc private func timesClicked(_ sender: UIButton) {
        self.textField.text = "\(sender.tag)"
    }
    
    @objc private func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc public override func backPopVC() {
        dismiss(animated: true, completion: nil)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        return true
    }
    
}
