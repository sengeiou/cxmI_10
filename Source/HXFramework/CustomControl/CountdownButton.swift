//
//  CountdownButton.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//  倒计时按钮

import UIKit

let remainingSecond = 60

protocol CountdownButtonDelegate: NSObjectProtocol {
    func countdownButClicked(button:CountdownButton) -> Void
}

class CountdownButton: UIButton {

    
    
    public weak var delegate : CountdownButtonDelegate!
    
    public var stop = true {
        didSet{
            if stop {
                isCounting = false
                let title = NSAttributedString(string: "获取短信验证码", attributes: [NSAttributedString.Key.foregroundColor: ColorA0A0A0])
                self.setAttributedTitle(title, for: .normal)
            }
        }
    }
    
    public var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = remainingSecond
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            
            self.isEnabled = !newValue
        }
    }
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            let second = NSAttributedString(string: "\(newValue)s", attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
            let title = NSMutableAttributedString(string: "验证码已发送", attributes: [NSAttributedString.Key.foregroundColor: ColorA0A0A0])
            title.append(second)
            
            self.setAttributedTitle(title, for: .normal)
            
            if newValue <= 0 {
                let title = NSAttributedString(string: "重新获取验证码", attributes: [NSAttributedString.Key.foregroundColor: ColorA0A0A0])
                self.setAttributedTitle(title, for: .normal)
                isCounting = false
            }
        }
    }
    
    @objc private func sendButtonClick(_ sender: CountdownButton) {
        //isCounting = true
        guard delegate != nil else { return }
        
        delegate.countdownButClicked(button: sender)
    }
    
    @objc private func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //self.backgroundColor = UIColor.red
        self.setTitleColor(ColorA0A0A0, for: .normal)
        self.setTitle("获取短信验证码", for: .normal)
        self.addTarget(self, action: #selector(sendButtonClick(_:)), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
