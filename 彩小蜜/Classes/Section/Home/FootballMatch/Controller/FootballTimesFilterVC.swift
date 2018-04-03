//
//  FootballTimesFilter.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//  倍数筛选

import UIKit

fileprivate let TimesViewHeight : CGFloat = 44 * defaultScale

class FootballTimesFilterVC: BasePopViewController, UITextFieldDelegate, CXMKeyboardViewDelegate {
    
    

    private var keyboardView: CXMKeyboardView!
    private var backBut: UIButton!
    private var timesTitle: UILabel!
    private var textField : UITextField!
    private var timesView: UIView!
    
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
            make.width.height.equalTo(30)
            make.left.equalTo(leftSpacing)
        }
        timesTitle.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(timesView.snp.top)
            make.right.equalTo(textField.snp.left).offset(-10)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(timesView.snp.top).offset(-10)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(screenWidth / 4 - rightSpacing)
        }
    }
    
    private func initSubview() {
        self.viewHeight = 260
        
        keyboardView = CXMKeyboardView()
        keyboardView.delegate = self
        
        backBut = UIButton(type: .custom)
        backBut.setBackgroundImage(UIImage(named: "jump"), for: .normal)
        backBut.addTarget(self, action: #selector(backClicked(_:)), for: .touchUpInside)
        
        timesTitle = UILabel()
        timesTitle.font = Font14
        timesTitle.textColor = Color505050
        timesTitle.textAlignment = .right
        timesTitle.sizeToFit()
        timesTitle.text = "倍数"
        
        textField = UITextField()
        textField.text = "1"
        textField.delegate = self
        textField.textColor = Color505050
        textField.borderStyle = .roundedRect
        
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
        but.layer.borderColor = ColorC8C8C8.cgColor
        but.addTarget(self, action: #selector(timesClicked(_:)), for: .touchUpInside)
        return but
    }
    
    // MARK: - 键盘  Delegate
    func keyboardDidTipItem(num: String) {
        guard let number = Int(self.textField.text!) else { return }
        guard number < 10000 else {
            self.textField.text = "99999"
            return }
        self.textField.text = self.textField.text! + num
    }
    
    func keyboardDelete() {
        guard textField.text != nil else { return }
        guard textField.text?.lengthOfBytes(using: .utf8) != 1 else {
            self.textField.text = "1"
            return
        }
        self.textField.text?.removeLast()
    }
    
    func keyboardConfirm() {
       
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    

}
