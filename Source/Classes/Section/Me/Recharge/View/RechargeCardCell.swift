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
    
    
    private let itemW = (screenWidth - 13.5 * 4) / 3
    private let itemH = cardHeight
    /** 列数  */
    private var colums:Int = 3
    
    /** 左边间距  */
    private var leftMargin:CGFloat = 13.5
    
    /** 右边间距  */
    private var rightMargin:CGFloat = 13.5
    
    /** 上边间距  */
    private var topMargin:CGFloat = 13.5
    
    /** 底部边间距  */
    private var bottomMargin:CGFloat = 13.5
    
    /** colums(每一列之间的间距)间距  */
    private var columsMargin:CGFloat = 13.5
    
    /** row(每一行之间的间距)间距  */
    private var rowMargin:CGFloat = 13.5
    
    
    var row = 0
    var colum = 0
    
    private var buttonArr : [UIButton] = []
    private var viewArr : [UIView] = []
    private var labelArr : [UILabel] = []
    private var indexArr : [Int] = []
    public var paymentModel : PaymentList!{
        didSet{
            guard paymentModel != nil else { return }
            _ = self.contentView.subviews.map {
                $0.removeFromSuperview()
            }
            initSubview()
        }
    }
    
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
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        
        
        if self.paymentModel != nil && self.paymentModel.isReadonly == "0"{
            textfield.isUserInteractionEnabled = true
        }else{
            textfield.isUserInteractionEnabled = false
        }
        
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(textfield)
        //        self.contentView.addSubview(card20)
        //        self.contentView.addSubview(card50)
        //        self.contentView.addSubview(card100)
        //        self.contentView.addSubview(card200)
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
        
        buttonArr.removeAll()
        viewArr.removeAll()
        labelArr.removeAll()
        indexArr.removeAll()
        
        if paymentModel != nil{
            for i in 0..<paymentModel.readMoney.count{
                let but = createCardBut(Int(paymentModel.readMoney[i].readmoney)!)
                buttonArr.append(but)
                
                let view = createCardView(UIImage(named: "赠送")!)
                let label = createCardLabel(String(paymentModel.readMoney[i].givemoney))
                viewArr.append(view)
                labelArr.append(label)
            }
        }
        
        for i in 0..<buttonArr.count{
            row = i / colums
            colum = i % colums
            self.contentView.addSubview(buttonArr[i])
            

            buttonArr[i].addSubview(viewArr[i])
            buttonArr[i].addSubview(labelArr[i])
            
            if paymentModel.readMoney[i].givemoney == "0"{
                let v = viewArr[i]
                let label = labelArr[i]
                v.isHidden = true
                label.isHidden = true
            }
            
            
            buttonArr[i].snp.makeConstraints { (make) in
                make.leading.equalTo(self.contentView).offset((self.leftMargin + (self.columsMargin + itemW) * colum.wd_CGFloat))
                make.top.equalTo(textfield.snp.bottom).offset((self.topMargin + (itemH + self.rowMargin) * row.wd_CGFloat))
                make.width.equalTo(itemW)
                make.height.equalTo(itemH)
            }
            

            labelArr[i].snp.makeConstraints { (make) in
                make.top.equalTo(buttonArr[i])
                make.right.equalTo(buttonArr[i]).offset(-8)
            }
            let labelWidth = getLabWidth(labelStr: labelArr[i].text!, font: Font12, height: 16)
            viewArr[i].snp.makeConstraints { (make) in
                make.top.equalTo(buttonArr[i])
                make.centerX.equalTo(labelArr[i])
                make.width.equalTo(labelWidth + 4)
                make.height.equalTo(18)
            }
        }

        
        
        //        card20.snp.makeConstraints { (make) in
        //            make.height.equalTo(cardHeight)
        //            make.width.equalTo(card50)
        //            make.left.equalTo(self.contentView).offset(19)
        //            make.top.equalTo(textfield.snp.bottom).offset(rowSpacing)
        //        }
        //        card50.snp.makeConstraints { (make) in
        //            make.height.width.top.equalTo(card100)
        //            make.left.equalTo(card20.snp.right).offset(13.5)
        //        }
        //        card100.snp.makeConstraints { (make) in
        //            make.height.width.top.equalTo(card20)
        //            make.left.equalTo(card50.snp.right).offset(13.5)
        //            make.right.equalTo(self.contentView).offset(-19)
        //        }
        
        //        card200.snp.makeConstraints { (make) in
        //            make.height.width.top.equalTo(card20)
        //            make.left.equalTo(card100.snp.right).offset(13.5)
        //            make.right.equalTo(self.contentView).offset(-19)
        //        }
        
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
    
    private func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: String = labelStr
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
        return strSize.width
    }
    
    
    private func createCardLabel(_ text : String) -> UILabel{
        let label = UILabel()
        label.font = Font11
        label.textColor = .white
        label.text = "送\(text)"
        return label
    }
    
    
    private func createCardView(_ image : UIImage) -> UIView {
        let v = UIView()
        v.layer.contents = image.cgImage
        return v
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



//MARK:⚠️当我们在大数转小数的时候,可能出现越界问题导致程序奔溃
//MARK:例如:12333333333333333333333333333333.33  转 Int8 就会奔溃
extension Double {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
    
    
}
extension Float {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension Int {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension Int8 {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension Int16 {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension Int32 {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension Int64 {
    
    var wd_Double: Double {
        return Double.init(self)
    }
    
    var wd_Int: Int {
        return Int.init(self)
    }
    
    var wd_Float:Float {
        
        return Float.init(self)
    }
    
    var wd_CGFloat:CGFloat {
        
        return CGFloat.init(self)
        
    }
    
    var wd_Int8:Int8 {
        
        return Int8.init(self)
    }
    
    var wd_Int16:Int16 {
        
        return Int16.init(self)
    }
    
    var wd_Int32:Int32 {
        
        return Int32.init(self)
    }
    
    var wd_Int64:Int64 {
        
        return Int64.init(self)
    }
}

extension CGRect {
    
    
    /// 这个任意类型只支持 CGFloat,String,Float,Int,Double,如果不是以上类型,x,y,width,height 的值都为 0
    ///
    /// - Parameters:
    ///   - x: 坐标x
    ///   - y: 坐标y
    ///   - width: 宽度
    ///   - height: 高度
    init(x: Any, y: Any, width: Any, height: Any) {
        self.init()
        
        func isInt(temp:Any) -> (Bool) {
            return temp is Int
        }
        
        func isDouble(temp:Any) -> (Bool) {
            return temp is Double
        }
        
        func isFloat(temp:Any) -> (Bool) {
            return temp is Float
        }
        
        func isCGFloat(temp:Any) -> (Bool) {
            
            return temp is CGFloat
        }
        
        func isString(temp:Any) -> (Bool) {
            return temp is String
        }
        
        var endX:Double = 0
        var endY:Double = 0
        var endWidth:Double = 0
        var endHeight:Double = 0
        
        if isString(temp: x) {
            
            let strX = x as! String
            endX = Double(strX)!
        } else if isDouble(temp: x) {
            
            let doubleX = x as! Double
            
            endX = Double.init(doubleX)
            
        } else if isFloat(temp: x) {
            
            let floatX = x as! Float
            
            endX = Double.init(floatX)
            
        } else if isCGFloat(temp: x) {
            
            let cgfloatX = x as! CGFloat
            endX = Double.init(cgfloatX)
            
        } else if isInt(temp: x) {
            
            let intX = x as! Int
            endX = Double.init(intX)
            
        } else {
            
            
        }
        
        if isString(temp: y) {
            
            let strY = y as! String
            endY = Double(strY)!
        } else if isDouble(temp: y) {
            
            let doubleY = y as! Double
            
            endY = Double.init(doubleY)
            
        } else if isFloat(temp: y) {
            
            let floatY = y as! Float
            
            endY = Double.init(floatY)
            
        } else if isCGFloat(temp: y) {
            
            let cgfloatY = y as! CGFloat
            endY = Double.init(cgfloatY)
            
        } else if isInt(temp: y) {
            
            let intY = y as! Int
            endY = Double.init(intY)
            
        } else {
            
            
        }
        
        if isString(temp: height) {
            
            let strH = height as! String
            endHeight = Double(strH)!
        } else if isDouble(temp: height) {
            
            let doubleH = height as! Double
            
            endHeight = Double.init(doubleH)
            
        } else if isFloat(temp: height) {
            
            let floatH = height as! Float
            
            endHeight = Double.init(floatH)
            
        } else if isCGFloat(temp: height) {
            
            let cgfloatH = height as! CGFloat
            endHeight = Double.init(cgfloatH)
            
        } else if isInt(temp: height) {
            
            let intH = height as! Int
            endHeight = Double.init(intH)
            
        } else {
            
            
        }
        
        if isString(temp: width) {
            
            let strW = width as! String
            endWidth = Double(strW)!
        } else if isDouble(temp: width) {
            
            let doubleW = width as! Double
            
            endWidth = Double.init(doubleW)
            
        } else if isFloat(temp: width) {
            
            let floatW = width as! Float
            
            endWidth = Double.init(floatW)
            
        } else if isCGFloat(temp: width) {
            
            let cgfloatW = width as! CGFloat
            endWidth = Double.init(cgfloatW)
            
        } else if isInt(temp: width) {
            
            let intW = width as! Int
            endWidth = Double.init(intW)
            
        } else {
            
        }
        
        self.init(x: endX, y: endY, width: endWidth, height: endHeight)
    }
    
}
