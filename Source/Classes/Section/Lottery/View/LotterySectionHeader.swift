//
//  LotterySectionHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
protocol LotterySectionHeaderDelegate {
    func spread(sender: UIButton, section : Int) -> Void
}
class LotterySectionHeader: UITableViewHeaderFooterView, DateProtocol {

    public var lotteryModel : LotteryModel! {
        didSet{
            guard lotteryModel != nil else { return }
            let srtData = lotteryModel.matchDateStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!
            let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html] //
            let attrStr = try? NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
            
            title.attributedText = attrStr
        }
    }
    
    public var resultList : [LotteryResultModel]! {
        didSet{
//            guard resultList != nil else { return }
//
//            if resultList.count == 0 {
//                title.text = "共有\(resultList.count)场比赛"
//            }else {
//                let model = resultList[0]
//
//                let time  = timeStampToYMD(model.matchTimeStart)
//
//                let week = getWeek(model.matchTimeStart, "周")
//
//                let att = NSMutableAttributedString(string: "")
//
//                let timeAtt = NSAttributedString(string: time)
//                let weekAtt = NSAttributedString(string: " " + week)
//                let totalAtt = NSAttributedString(string: "共有")
//
//                let countAtt = NSAttributedString(string: "\(resultList.count)", attributes: [NSAttributedString.Key.foregroundColor : ColorE85504])
//
//                let lAtt = NSAttributedString(string: "场比赛")
//
//                att.append(timeAtt)
//                att.append(weekAtt)
//                att.append(totalAtt)
//
//                att.append(countAtt)
//                att.append(lAtt)
//
//                title.attributedText = att
          //  }
        }
    }
    
    public var delegate : LotterySectionHeaderDelegate!
    
    //private var icon : UIImageView!
    private var title : UILabel!
    private var spreadBut : UIButton!
    private var bgView: UIView!
    
    private var line : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(5 * defaultScale)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-1.5)
        }
        
//        line.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-0.5)
//            make.left.equalTo(leftSpacing)
//            make.right.equalTo(-rightSpacing)
//            make.height.equalTo(0.6)
//        }
        

        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-10)
        }
//        spreadBut.snp.makeConstraints { (make) in
//            make.centerY.equalTo(bgView.snp.centerY)
//            make.right.equalTo(-rightSpacing)
//            make.width.height.equalTo(20)
//        }
    }
    private func initSubview() {
        self.contentView.backgroundColor = ColorF4F4F4
        
        line = UIView()
        line.backgroundColor = ColorC8C8C8
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        title = UILabel()
        title.font = Font14
        title.textAlignment = .left
        title.textColor = Color9F9F9F
        title.text = "共有0场比赛 "
        
        spreadBut = UIButton(type: .custom)
        spreadBut.setImage(UIImage(named: "Unfold"), for: .normal)
        spreadBut.addTarget(self, action: #selector(spreadClicked(_:)), for: .touchUpInside)
        spreadBut.isSelected = true
        
        bgView.addSubview(title)
        //bgView.addSubview(spreadBut)
        self.contentView.addSubview(line)
        self.contentView.addSubview(bgView)
    }
    
    @objc private func spreadClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard delegate != nil else { return }
        delegate.spread(sender: sender, section: self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
