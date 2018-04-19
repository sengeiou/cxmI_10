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
class LotterySectionHeader: UITableViewHeaderFooterView {

    public var resultList : [LotteryResultModel]! {
        didSet{
            guard resultList != nil else { return }
            if resultList.count == 0 {
                title.text = "共有\(resultList.count)场比赛"
            }else {
                var count = 0
                for result in resultList {
                    if result.matchFinish == "1" {
                        count += 1
                    }
                }
                
                let att = NSMutableAttributedString(string: "共有\(resultList.count)场比赛 已经结束")
                
                let attCount = NSAttributedString(string: "\(count)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                let chang = NSAttributedString(string: "场")
                att.append(attCount)
                att.append(chang)
                title.attributedText = att
            }
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
        title.text = "共有14场比赛 "
        
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
