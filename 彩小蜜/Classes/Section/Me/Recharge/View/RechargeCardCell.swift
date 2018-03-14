//
//  RechargeCardCell
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit




let RechargeCardCellIdentifier = "RechargeCardCellIdentifier"

let titleHeight = 20
let rowSpacing = 10
let textfieldHeight = 40
let cardHeight = 40

class RechargeCardCell: UITableViewCell {

    //MARK: 点击事件
    @objc private func cartButClicked(_ sender: UIButton) {
        self.textfield.text = "\(sender.tag)"
    }
    
    //MARK: - 属性
    private var title : UILabel! //
    public var textfield : UITextField!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        title = UILabel()
        title.font = Font14
        title.text = "充值金额"
        title.textColor = UIColor.black
        title.textAlignment = .left
        
        textfield = UITextField()
        textfield.font = Font13
        textfield.placeholder = "请输入充值金额"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        
        let card20 = createCardBut(20)
        let card50 = createCardBut(50)
        let card100 = createCardBut(100)
        let card200 = createCardBut(200)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(textfield)
        self.contentView.addSubview(card20)
        self.contentView.addSubview(card50)
        self.contentView.addSubview(card100)
        self.contentView.addSubview(card200)
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        textfield.snp.makeConstraints { (make) in
            make.height.equalTo(textfieldHeight)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(title.snp.bottom).offset(rowSpacing)
        }
        card20.snp.makeConstraints { (make) in
            make.height.equalTo(cardHeight)
            make.width.equalTo(card50)
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(textfield.snp.bottom).offset(rowSpacing)
        }
        card50.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card20.snp.right).offset(10)
        }
        card100.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card50.snp.right).offset(10)
        }
        card200.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card100.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
    }
    
    private func createCardBut(_ tag : Int) -> UIButton {
        let but = UIButton(type: .custom)
        but.tag = tag
        but.setTitle(String(tag), for: .normal)
        but.setTitleColor(UIColor.black, for: .normal)
        but.layer.cornerRadius = 5
        but.backgroundColor = UIColor.gray
        but.layer.borderWidth = 1
        but.layer.borderColor = UIColor.black.cgColor
        but.addTarget(self, action: #selector(cartButClicked(_:)), for: .touchUpInside)
        
        return but
    }
    
    static public func height() -> CGFloat {
        return CGFloat(titleHeight + textfieldHeight + cardHeight + rowSpacing * 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
