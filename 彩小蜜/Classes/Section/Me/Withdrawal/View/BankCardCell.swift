//
//  BankCardCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let bankCardIdentifier = "bankCardIdentifier"

protocol BankCardCellDelegate {
    func deleteCard() -> Void
    func settingDefaultCard(_ bankInfo : BankCardInfo) -> Void
}

class BankCardCell: UITableViewCell {

    //MARK: - 点击事件
    @objc private func deleteCard(_ sender: UIButton) {
        
    }
    @objc private func settingDefaultCard(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard  delegate != nil else { return }
        delegate.settingDefaultCard(self.bankInfo)
        
    }
    
    public var bankInfo : BankCardInfo! {
        didSet{
            if let url = URL(string: bankInfo.bankLogo) {
                bankIcon.kf.setImage(with: url)
            }
            
            bankName.text = bankInfo.bankName
            bankCardNum.text = bankInfo.cardNo
        }
    }
    
    //MARK: - 属性
    public var delegate : BankCardCellDelegate!
    
    private var bankIcon : UIImageView! // 银行LOGO
    private var bankName : UILabel!     // 银行名字
    private var bankCardNum : UILabel!  // 银行卡号
    private var bankCardState : UIButton! // 是否为默认收款卡
    private var deleteBut : UIButton!   // 删除按钮
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bankIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(10)
        }
        bankName.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(bankIcon.snp.right).offset(10)
            make.right.equalTo(deleteBut.snp.left).offset(-10)
            make.top.equalTo(self.contentView).offset(15)
        }
        bankCardNum.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.top.equalTo(bankIcon.snp.bottom).offset(verticalSpacing)
            make.bottom.equalTo(bankCardState.snp.top).offset(-verticalSpacing)
        }
        bankCardState.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.bottom.equalTo(self.contentView).offset(-verticalSpacing)
            
        }
        deleteBut.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.top.equalTo(bankIcon)
        }
    }
    //MARK: - UI
    private func initSubview() {
        bankIcon = UIImageView()
        
        bankName = UILabel()
        bankName.font = Font14
        bankName.textColor = UIColor.black
        bankName.textAlignment = .left
        
        bankCardNum = UILabel()
        bankCardNum.font = Font12
        bankCardNum.textColor = UIColor.black
        bankCardNum.textAlignment = .center
        
        bankCardState = UIButton(type: .custom)
        bankCardState.setTitle("默认收款卡", for: .normal)
        bankCardState.setTitle("默认收款卡", for: .selected)
        bankCardState.setTitleColor(UIColor.black, for: .normal)
        bankCardState.setImage(UIImage(named: "userID"), for: .normal)
        bankCardState.setImage(UIImage(named: "userID"), for: .selected)
        bankCardState.contentHorizontalAlignment = .left
        bankCardState.addTarget(self, action: #selector(settingDefaultCard(_:)), for: .touchUpInside)
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "redarrow"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteCard(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(bankIcon)
        self.contentView.addSubview(bankName)
        self.contentView.addSubview(bankCardNum)
        self.contentView.addSubview(deleteBut)
        self.contentView.addSubview(bankCardState)
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
    static public func height() -> CGFloat {
        return 130
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
