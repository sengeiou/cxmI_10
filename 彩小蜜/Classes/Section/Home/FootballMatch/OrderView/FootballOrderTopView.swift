//
//  FootballOrderTopView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOrderTopView: UIView, DateProtocol {

    public var playModelList : [FootballPlayListModel]! {
        didSet{
            guard playModelList.isEmpty == false else { return }
            
            var arr = [Int]()
            for model in playModelList {
                arr.append(model.betEndTime)
            }
            
            guard let timeInt = arr.min() else { return }
            
            let time = timeStampToHHmm(timeInt)
            
            let attStr = NSMutableAttributedString(string: "已选\(playModelList.count)场比赛 投注截止时间：", attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
            let att = NSAttributedString(string: time, attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            attStr.append(att)
            
            titleLB.attributedText = attStr
            
        }
    }
    
    private var titleLB: UILabel!
    private var bgView: UIView!
    private var line : UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorF4F4F4
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        
        bgView.addSubview(titleLB)
        self.addSubview(bgView)
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
