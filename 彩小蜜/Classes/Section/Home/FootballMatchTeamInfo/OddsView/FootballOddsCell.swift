//
//  FootballOddsCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOddsCell: UITableViewCell {

    /// 欧赔
    public var europeInfo : MatchEuropeModel! {
        didSet{
            company.text = europeInfo.comName

            var homeColor = Color505050
            var homeUp = ""
            var visiColor = Color505050
            var visiUp = ""
            
            var flatColor = Color505050
            var flatUp = ""
            
            if europeInfo.winChange == "1" {
                homeColor = ColorEA5504
                homeUp = "↑"
            }else if europeInfo.winChange == "2" {
                homeColor = Color44AE35
                homeUp = "↓"
            }
            
            if europeInfo.drawChange == "1" {
                flatColor = ColorEA5504
                flatUp = "↑"
            }else if europeInfo.drawChange == "2" {
                flatColor = Color44AE35
                flatUp = "↓"
            }
            
            if europeInfo.loseChange == "1" {
                visiColor = ColorEA5504
                visiUp = "↑"
            }else if europeInfo.loseChange == "2" {
                visiColor = Color44AE35
                visiUp = "↓"
            }
            
            let homeMuAtt = NSMutableAttributedString(string: "\(europeInfo.initWin!)\n")
            let homeAtt = NSAttributedString(string: "\(europeInfo.realWin!)\(homeUp)", attributes: [NSAttributedStringKey.foregroundColor: homeColor])
            homeMuAtt.append(homeAtt)
            
            let flatMuAtt = NSMutableAttributedString(string: "\(europeInfo.initDraw!)\n")
            let flatAtt = NSAttributedString(string: "\(europeInfo.realDraw!)\(flatUp)", attributes: [NSAttributedStringKey.foregroundColor: flatColor])
            flatMuAtt.append(flatAtt)
            
            let visiMuAtt = NSMutableAttributedString(string: "\(europeInfo.initLose!)\n")
            let visiAtt = NSAttributedString(string: "\(europeInfo.realLose!)\(visiUp)", attributes: [NSAttributedStringKey.foregroundColor: visiColor])
            visiMuAtt.append(visiAtt)
            
            homelb.attributedText = homeMuAtt
            flatlb.attributedText = flatMuAtt
            visilb.attributedText = visiMuAtt
        }
    }
    /// 亚盘
    public var asiaInfo : MatchAsiasModel! {
        didSet{
            company.text = asiaInfo.comName
            flatlb.text = "\(asiaInfo.initRule!)\n\(asiaInfo.realRule!)"
            
            
            var homeColor = Color505050
            var homeUp = ""
            var visiColor = Color505050
            var visiUp = ""
            if asiaInfo.odds1Change == "1" {
                homeColor = ColorEA5504
                homeUp = "↑"
            }else if asiaInfo.odds1Change == "2" {
                homeColor = Color44AE35
                homeUp = "↓"
            }
            
            if asiaInfo.odds2Change == "1" {
                visiColor = ColorEA5504
                visiUp = "↑"
            }else if asiaInfo.odds2Change == "2" {
                visiColor = Color44AE35
                visiUp = "↓"
            }
            
            let homeMuAtt = NSMutableAttributedString(string: "\(asiaInfo.initOdds1!)\n")
            let homeAtt = NSAttributedString(string: "\(asiaInfo.realOdds1!)\(homeUp)", attributes: [NSAttributedStringKey.foregroundColor: homeColor])
            homeMuAtt.append(homeAtt)
            
            let visiMuAtt = NSMutableAttributedString(string: "\(asiaInfo.initOdds2!)\n")
            let visiAtt = NSAttributedString(string: "\(asiaInfo.realOdds2!)\(visiUp)", attributes: [NSAttributedStringKey.foregroundColor: visiColor])
            visiMuAtt.append(visiAtt)
            
            homelb.attributedText = homeMuAtt
            visilb.attributedText = visiMuAtt
        }
    }
    /// 大小球
    public var daxiaoInfo : MatchDaxiaoqModel! {
        didSet{
            company.text = daxiaoInfo.comName
            
            var homeColor = Color505050
            var homeUp = ""
            var visiColor = Color505050
            var visiUp = ""
            
            var flatColor = Color505050
            var flatUp = ""
            
            if daxiaoInfo.winChange == "1" {
                homeColor = ColorEA5504
                homeUp = "↑"
            }else if daxiaoInfo.winChange == "2" {
                homeColor = Color44AE35
                homeUp = "↓"
            }
            
            if daxiaoInfo.drawChange == "1" {
                flatColor = ColorEA5504
                flatUp = "↑"
            }else if daxiaoInfo.drawChange == "2" {
                flatColor = Color44AE35
                flatUp = "↓"
            }
            
            if daxiaoInfo.loseChange == "1" {
                visiColor = ColorEA5504
                visiUp = "↑"
            }else if daxiaoInfo.loseChange == "2" {
                visiColor = Color44AE35
                visiUp = "↓"
            }
            
            let homeMuAtt = NSMutableAttributedString(string: "\(daxiaoInfo.initWin!)\n")
            let homeAtt = NSAttributedString(string: "\(daxiaoInfo.realWin!)\(homeUp)", attributes: [NSAttributedStringKey.foregroundColor: homeColor])
            homeMuAtt.append(homeAtt)
            
            let flatMuAtt = NSMutableAttributedString(string: "\(daxiaoInfo.initDraw!)\n")
            let flatAtt = NSAttributedString(string: "\(daxiaoInfo.realDraw!)\(flatUp)", attributes: [NSAttributedStringKey.foregroundColor: flatColor])
            flatMuAtt.append(flatAtt)
            
            let visiMuAtt = NSMutableAttributedString(string: "\(daxiaoInfo.initLose!)\n")
            let visiAtt = NSAttributedString(string: "\(daxiaoInfo.realLose!)\(visiUp)", attributes: [NSAttributedStringKey.foregroundColor: visiColor])
            visiMuAtt.append(visiAtt)
            
            homelb.attributedText = homeMuAtt
            flatlb.attributedText = flatMuAtt
            visilb.attributedText = visiMuAtt
        }
    }
    
    
    
    public var homelb : UILabel!
    public var flatlb : UILabel!
    private var oddslb : UILabel!
    private var company : UILabel!
    private var visilb : UILabel!
    private var topLine : UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        company.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(5 * defaultScale)
            make.width.equalTo(72 * defaultScale)
        }
        oddslb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.left.equalTo(company.snp.right)
            make.right.equalTo(homelb.snp.left)
        }
        homelb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.width.equalTo(40 * defaultScale)
            make.left.equalTo(company.snp.right).offset(80 * defaultScale)
        }
        flatlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.left.equalTo(homelb.snp.right)
            make.right.equalTo(visilb.snp.left)
        }
        visilb.snp.makeConstraints { (make) in
            make.width.equalTo(homelb)
            make.right.equalTo(-16 * defaultScale)
            make.top.bottom.equalTo(company)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        topLine = UIImageView()
        topLine.image = UIImage(named: "line")
        
        company = getLabel("公司")
        oddslb = getLabel("初赔\n即赔")
        
        homelb = getLabel("胜")
        
        flatlb = getLabel("平")
        visilb = getLabel("负")
        
        self.addSubview(topLine)
        self.addSubview(company)
        self.addSubview(homelb)
        self.addSubview(flatlb)
        self.addSubview(visilb)
        self.addSubview(oddslb)
    }
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.text = title
        lab.font = Font12
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        lab.numberOfLines = 2
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
