//
//  RechargeCardCell
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit






fileprivate let titleHeight : CGFloat = 20
fileprivate let rowSpacing : CGFloat = 13.5
fileprivate let textfieldHeight : CGFloat = 36
fileprivate let cardHeight : CGFloat = 36
fileprivate let topSpacing : CGFloat = 17

protocol RechargeCardCellDelegate {
    func didSelectedCard(cell : RechargeCardCell, amount: String) -> Void
}

class RechargeCardCell: UITableViewCell {

   
    
    //MARK: - 属性
    public var giveAmount : String! {
        didSet{
            guard giveAmount != nil else { return }
            //guard isNewUser != nil else { return }
            activityMoney.text = giveAmount
//            if isNewUser == "0" {
//                activityMoney.text = "送\(giveAmount!)元"
//            }else if isNewUser == "1" {
//                activityMoney.text = "最高可送\(giveAmount!)元"
//            }
        }
    }
    //public var isNewUser : String!
    
    public var delegate :RechargeCardCellDelegate!
    
    private var title : UILabel! //
    public var textfield : CustomTextField!
    public var activityImageView : UIImageView!
    private var activityMoney : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    //MARK: 点击事件
    @objc private func cartButClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didSelectedCard(cell: self, amount: "\(sender.tag)")
        TongJi.log(.充值固定金额, label: "充值固定金额")
    }
    
    
    
    private func initSubview() {
        self.selectionStyle = .none
        
        title = UILabel()
        title.font = Font14
        title.text = "充值金额"
        title.textColor = UIColor.black
        title.textAlignment = .left
        
        activityImageView = UIImageView()
        activityImageView.image = UIImage(named: "Label")
        activityImageView.isHidden = true
        
        activityMoney = UILabel()
        activityMoney.font = Font12
        activityMoney.textColor = ColorFFFFFF
        activityMoney.textAlignment = .center
//        activityMoney.text = "送10元优惠券"
        
        
        textfield = CustomTextField()
        textfield.font = Font14
        textfield.placeholder = "请输入整数的充值金额"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = ColorC8C8C8.cgColor
        textfield.textColor = ColorE95504
        
        
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
        self.contentView.addSubview(activityImageView)
        activityImageView.addSubview(activityMoney)
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.top.equalTo(self.contentView).offset(topSpacing)
            make.left.equalTo(self.contentView).offset(19)
            make.right.equalTo(self.contentView).offset(-19)
        }
        textfield.snp.makeConstraints { (make) in
            make.height.equalTo(textfieldHeight)
            make.left.equalTo(self.contentView).offset(19)
            make.right.equalTo(self.contentView).offset(-19)
            make.top.equalTo(title.snp.bottom).offset(rowSpacing)
        }
        card20.snp.makeConstraints { (make) in
            make.height.equalTo(cardHeight)
            make.width.equalTo(card50)
            make.left.equalTo(self.contentView).offset(19)
            make.top.equalTo(textfield.snp.bottom).offset(rowSpacing)
        }
        card50.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card20.snp.right).offset(13.5)
        }
        card100.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card50.snp.right).offset(13.5)
        }
        card200.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(card20)
            make.left.equalTo(card100.snp.right).offset(13.5)
            make.right.equalTo(self.contentView).offset(-19)
        }
        activityImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(textfield.snp.top).offset(-4)
            make.height.equalTo(30)
            make.right.equalTo(textfield)
            //make.width.equalTo(80)
        }
        activityMoney.snp.makeConstraints { (make) in
            //make.top.left.right.equalTo(0)
            make.top.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-6)
        }
    }
    
    private func createCardBut(_ tag : Int) -> UIButton {
        let but = UIButton(type: .custom)
        but.tag = tag
        but.setTitle(String(tag), for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.titleLabel?.font = Font13
        but.layer.cornerRadius = 5
        but.layer.borderWidth = 1
        but.layer.borderColor = ColorC8C8C8.cgColor
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
