//
//  NumberUpdownView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/4.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit
import RxSwift

protocol NumPlusReduceViewProtocol {
    func reduce(view : NumPlusReduceView) -> Void
    func plus(view : NumPlusReduceView) -> Void
}

class NumPlusReduceView: UIView {

    public var delegate : NumPlusReduceViewProtocol!
    public var viewModel : NumPlusReduceViewModel! 
    
    private var reduceButton : UIButton!
    private var plusButton : UIButton!
    
    public var textField : UITextField!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension NumPlusReduceView {
    public func configure(with data : String) {
//        textField.text = data
        
        _ = viewModel.number.subscribe { (event) in
           
            self.textField.text = event.element
        }
        _ = viewModel.imageStr.subscribe({ (event) in
            if let imageStr = event.element {
                self.reduceButton.setImage(UIImage(named: imageStr), for: .normal)
            }
        })
    }
}
extension NumPlusReduceView: UITextFieldDelegate {
    @objc private func buttonClicked(sender : UIButton) {
        guard delegate != nil else { return }
        switch sender.tag {
        case 100:
            delegate.reduce(view: self)
        case 200:
            delegate.plus(view: self)
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text != nil else { return true }
        guard string != "" else { return true }
        if let num = Int(self.textField.text! + string) {
            viewModel.changeNum(num: num)
        }
        
        return false
    }
}

extension NumPlusReduceView {
    private func initSubview() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorEDEDED.cgColor
        
        reduceButton = getButton(image: "--", tag: 100)
        plusButton = getButton(image: "+", tag: 200)
        
        textField = UITextField(frame: CGRect.zero)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.text = "1"
        
        self.addSubview(reduceButton)
        self.addSubview(plusButton)
        self.addSubview(textField)
        
        reduceButton.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(reduceButton.snp.height)
        }
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(reduceButton.snp.right).offset(0)
            make.right.equalTo(plusButton.snp.left).offset(0)
        }
        plusButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(reduceButton)
            make.right.equalTo(0)
            make.width.equalTo(reduceButton)
        }
    }
    private func getButton(image : String, tag : Int) -> UIButton {
        let but = UIButton(type: .custom)
        but.tag = tag
        but.setImage(UIImage(named: image), for: .normal)
        but.layer.borderColor = ColorEDEDED.cgColor
        but.layer.borderWidth = 1
        but.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return but
    }
}
