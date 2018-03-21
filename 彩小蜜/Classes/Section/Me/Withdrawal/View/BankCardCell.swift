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
    func deleteCard(bankInfo : BankCardInfo) -> Void
    func settingDefaultCard(_ bankInfo : BankCardInfo) -> Void
}

class BankCardCell: UITableViewCell {

    //MARK: - 点击事件
    @objc private func deleteCard(_ sender: UIButton) {
        guard  delegate != nil else { return }
        delegate.deleteCard(bankInfo: self.bankInfo)
    }
    @objc private func settingDefaultCard(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        
        guard  delegate != nil else { return }
        delegate.settingDefaultCard(self.bankInfo)
        
    }
    
    public var bankInfo : BankCardInfo! {
        didSet{
            if let url = URL(string: bankInfo.bankLogo) {
                bankIcon.kf.setImage(with: url)
            }
            if bankInfo.status == "1" {
                self.bankCardState.isSelected = true
            }else {
                self.bankCardState.isSelected = false
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
    private var bankType: UILabel!     // 银行卡类型
    
    private var bgView : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(sectionHeaderHeight)
            make.bottom.equalTo(self.contentView).offset(-sectionHeaderHeight)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
        bankIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.left.equalTo(bgView).offset(10)
            make.top.equalTo(bgView).offset(10)
        }
        
        bankName.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(bankIcon.snp.right).offset(10)
            make.right.equalTo(deleteBut.snp.left).offset(-10)
            make.top.equalTo(bgView).offset(15)
        }
        bankType.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(bankName)
            make.top.equalTo(bankName.snp.bottom).offset(1)
        }
        bankCardNum.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bankType.snp.bottom).offset(verticalSpacing)
            make.bottom.equalTo(bankCardState.snp.top).offset(-verticalSpacing)
        }
        bankCardState.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.bottom.equalTo(bgView).offset(-verticalSpacing)
        }
        deleteBut.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bankIcon)
        }
    }
    //MARK: - UI
    private func initSubview() {
        bgView = UIView()
        bgView.layer.cornerRadius = 3
        bgView.backgroundColor = UIColor.red
        
        bankIcon = UIImageView()
        
        bankName = UILabel()
        bankName.font = Font14
        bankName.textColor = ColorFFFFFF
        bankName.textAlignment = .left
        
        bankType = UILabel()
        bankType.font = Font14
        bankType.textColor = ColorFFFFFF
        bankType.textAlignment = .left
        
        bankCardNum = UILabel()
        bankCardNum.font = Font12
        bankCardNum.textColor = ColorFFFFFF
        bankCardNum.textAlignment = .center
        
        bankCardState = UIButton(type: .custom)
        bankCardState.setTitle("默认收款卡", for: .normal)
        bankCardState.setTitle("默认收款卡", for: .selected)
        bankCardState.setTitleColor(ColorFFFFFF, for: .selected)
        bankCardState.setTitleColor(ColorA0A0A0, for: .normal)
        bankCardState.setImage(UIImage(named: "jump"), for: .normal)
        bankCardState.setImage(UIImage(named: "name"), for: .selected)
        bankCardState.contentHorizontalAlignment = .left
        bankCardState.addTarget(self, action: #selector(settingDefaultCard(_:)), for: .touchUpInside)
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "redarrow"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteCard(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(bankIcon)
        bgView.addSubview(bankName)
        bgView.addSubview(bankType)
        bgView.addSubview(bankCardNum)
        bgView.addSubview(deleteBut)
        bgView.addSubview(bankCardState)
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
    static public func height() -> CGFloat {
        return BankCardHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
