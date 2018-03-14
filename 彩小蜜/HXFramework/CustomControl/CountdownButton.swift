//
//  CountdownButton.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//  倒计时按钮

import UIKit

let remainingSecond = 1

protocol CountdownButtonDelegate: NSObjectProtocol {
    func countdownButClicked(button:CountdownButton) -> Void
}

class CountdownButton: UIButton {

    
    
    public weak var delegate : CountdownButtonDelegate!
    
    public var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = remainingSecond
                
                self.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                self.backgroundColor = UIColor.red
            }
            
            self.isEnabled = !newValue
        }
    }
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            self.setTitle("\(newValue)秒后重新获取", for: .normal)
            
            if newValue <= 0 {
                self.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    @objc private func sendButtonClick(_ sender: CountdownButton) {
        isCounting = true
        guard delegate != nil else { return }
        
        delegate.countdownButClicked(button: sender)
    }
    
    @objc private func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.backgroundColor = UIColor.red
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitle("获取验证码", for: .normal)
        self.addTarget(self, action: #selector(sendButtonClick(_:)), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
