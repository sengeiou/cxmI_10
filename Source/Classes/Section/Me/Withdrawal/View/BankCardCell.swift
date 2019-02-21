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
        guard self.bankInfo != nil else { return }
        delegate.deleteCard(bankInfo: self.bankInfo)
    }
    @objc private func settingDefaultCard(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        
        guard  delegate != nil else { return }
        guard self.bankInfo != nil else { return }
        delegate.settingDefaultCard(self.bankInfo)
        
    }
    
    public var bankInfo : BankCardInfo! {
        didSet{
            guard bankInfo != nil else { return }
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
            
            switch bankInfo.cardType {
            case "1":
                bankType.text = "储蓄卡"
            default:
                bankType.text = ""
            }
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
    
    private var bankIconBg : UIView!
    
    private var bgView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            
            make.height.equalTo(BankCardHeight)
            make.width.equalTo(BankCardWidth)
            //make.top.equalTo(self.contentView).offset(sectionHeaderHeight)
            //make.bottom.equalTo(self.contentView).offset(-sectionHeaderHeight)
//            make.left.equalTo(self.contentView).offset(leftSpacing)
//            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        bankIconBg.snp.makeConstraints { (make) in
            make.height.width.equalTo(BankCardIconWidth)
            make.left.equalTo(bgView).offset(12)
            make.top.equalTo(bgView).offset(12)
        }
        bankIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(2)
            make.right.bottom.equalTo(-2)
        }
        
        bankName.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            //make.left.equalTo(bgView).offset(12)
            make.left.equalTo(bankIconBg.snp.right).offset(6)
            make.right.equalTo(deleteBut.snp.left).offset(-10)
            make.top.equalTo(bgView).offset(10.5)
        }
        bankType.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(bankName)
            make.top.equalTo(bankName.snp.bottom).offset(1)
        }
        bankCardNum.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bankType.snp.bottom).offset(1)
            make.height.equalTo(20)
        }
        bankCardState.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.bottom.equalTo(bgView).offset(-verticalSpacing)
        }
        deleteBut.snp.makeConstraints { (make) in
            make.height.width.equalTo(BankCardDeleteWidth * 3)
            make.right.equalTo(bgView).offset(-7)
            make.top.equalTo(bgView).offset(7)
        }
    }
    //MARK: - UI
    private func initSubview() {
        self.selectionStyle = .none
        
        bgView = UIView()
        bgView.layer.cornerRadius = 3
        bgView.backgroundColor = ColorCC4050
        
        bankIcon = UIImageView()
        bankIcon.backgroundColor = ColorFFFFFF
        
        
        bankIconBg = UIView()
        bankIconBg.backgroundColor = ColorFFFFFF
        bankIconBg.layer.cornerRadius = BankCardIconWidth / 2
        bankIconBg.layer.masksToBounds = true
        
        bankName = UILabel()
        bankName.font = Font14
        bankName.textColor = ColorFFFFFF
        bankName.textAlignment = .left
        
        bankType = UILabel()
        bankType.font = Font10
        bankType.textColor = ColorFFFFFF
        bankType.textAlignment = .left
        bankType.text = "储蓄卡"
        
        bankCardNum = UILabel()
        bankCardNum.font = Font18
        bankCardNum.textColor = ColorFFFFFFa8
        bankCardNum.textAlignment = .center
        
        bankCardState = UIButton(type: .custom)
        bankCardState.titleLabel?.font = Font12
        bankCardState.setTitle("默认收款卡", for: .normal)
        bankCardState.setTitle("默认收款卡", for: .selected)
        bankCardState.setTitleColor(ColorFFFFFF, for: .selected)
        bankCardState.setTitleColor(ColorFFFFFFa8, for: .normal)
        bankCardState.setImage(UIImage(named: "Confirmationbox"), for: .normal)
        bankCardState.setImage(UIImage(named: "recharge"), for: .selected)
        bankCardState.contentHorizontalAlignment = .left
        bankCardState.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        bankCardState.addTarget(self, action: #selector(settingDefaultCard(_:)), for: .touchUpInside)
        
        deleteBut = UIButton(type: .custom)
        //deleteBut.setBackgroundImage(UIImage(named: "shut"), for: .normal)
        deleteBut.setImage(UIImage(named: "shut"), for: .normal)
        deleteBut.imageEdgeInsets = UIEdgeInsets(top: 0, left: BankCardDeleteWidth * 2, bottom: BankCardDeleteWidth * 2, right: 0)
        deleteBut.addTarget(self, action: #selector(deleteCard(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(bgView)
        //bgView.addSubview(bankIcon)
        bgView.addSubview(bankName)
        bgView.addSubview(bankType)
        bgView.addSubview(bankCardNum)
        bgView.addSubview(deleteBut)
        bgView.addSubview(bankCardState)
        bgView.addSubview(bankIconBg)
        bankIconBg.addSubview(bankIcon)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static public func height() -> CGFloat {
        return BankCardHeight + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
