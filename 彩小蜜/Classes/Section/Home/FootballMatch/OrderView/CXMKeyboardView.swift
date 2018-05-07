//
//  CXMKeyboardView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let KeyboardHeight : CGFloat = 144 * defaultScale

fileprivate let itemWidth: CGFloat = screenWidth / 4
fileprivate let itemHeight : CGFloat = KeyboardHeight / 4

protocol CXMKeyboardViewDelegate {
    func keyboardDidTipItem(num: String) -> Void
    func keyboardDelete() -> Void
    func keyboardConfirm() -> Void
}

class CXMKeyboardView: UIView {

    public var delegate: CXMKeyboardViewDelegate!
    
    private var keyboardView : UIView!
    private var deleteBut : UIButton!
    private var confirmBut: UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteBut.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.equalTo(itemWidth)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.width.height.equalTo(deleteBut)
            make.top.equalTo(deleteBut.snp.bottom)
        }
        keyboardView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(deleteBut.snp.left)
        }
    }
    private func initSubview() {
        keyboardView = UIView()
        keyboardView.backgroundColor = ColorFFFFFF
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setTitle("删除", for: .normal)
        deleteBut.setTitleColor(Color505050, for: .normal)
        deleteBut.backgroundColor = ColorFFFFFF
        deleteBut.layer.borderWidth = 0.3
        deleteBut.layer.borderColor = ColorC8C8C8.cgColor
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确认", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.addSubview(keyboardView)
        self.addSubview(deleteBut)
        self.addSubview(confirmBut)
        
        initKeyboardView()
    }
    
    private func initKeyboardView() {
        var i = 1
        for index in 0...3 {
            for ind in 0...2 {
                let item = getKeyboardItem()
               
                
                item.frame = CGRect(x: CGFloat(ind) * itemWidth + 0.1, y: CGFloat(index) * itemHeight + 0.1, width: itemWidth, height: itemHeight)

                if i == 10 {
                    item.tag = 0
                    item.setTitle("\(item.tag)", for: .normal)
                }else if i == 11 {
                    item.setTitle("", for: .normal)
                }else if i == 12 {
                    item.setTitle("", for: .normal)
                }else {
                    item.tag = i
                    item.setTitle("\(item.tag)", for: .normal)
                }
                
                
                self.keyboardView.addSubview(item)
                i += 1
            }
        }
        
    }
    private func getKeyboardItem() -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitleColor(Color505050, for: .normal)
        but.layer.borderWidth = 0.3
        but.titleLabel?.font = Font14
        but.layer.borderColor = ColorC8C8C8.cgColor
        but.addTarget(self, action: #selector(didTipItem(_:)), for: .touchUpInside)
        return but
    }
    
    @objc private func deleteClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.keyboardDelete()
    }
    @objc private func confirmClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.keyboardConfirm()
    }
    @objc private func didTipItem(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.keyboardDidTipItem(num: "\(sender.tag)")
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
