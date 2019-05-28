//
//  HomeActivityView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/5/22.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit


protocol HomeActivityViewDelegate {
    func didTipActivity(link : String) -> Void
    func deleteHide() -> Void
}


class HomeActivityView: BasicDialog {

    public var delegate : HomeActivityViewDelegate!
    public var activityModel : [ActivityModel]!
    
    lazy var deleteBut : UIButton = {
        let but = UIButton(type: .custom)
        //        but.setImage(UIImage(named: "关闭"), for: .normal)
        but.setBackgroundImage(UIImage(named: "关闭"), for: .normal)
        but.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return but
    }()
    
    lazy public var imageView : UIImageView = {
        var imageView = UIImageView()
        //        imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTipImageView))
        
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy public var titlelLabel : UILabel = {
        var titlelLabel = UILabel()
        titlelLabel.font = Font20
        titlelLabel.textColor = .blue
        return titlelLabel
    }()
    
    
    lazy public var detailLabel : UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = Font20
        detailLabel.textColor = .red
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        return detailLabel
    }()
    
    override func createView() {
        addDialogToWindow()
    }
    
}


// MARK: - 点击事件
extension HomeActivityView {
    @objc private func didTipImageView() {
        guard delegate != nil else { return }
        delegate.didTipActivity(link: "")
        self.hide()
        popNumber += 1
    }
    
    @objc private func deleteClicked() {
        self.hide()
        popNumber += 1
        delegate.deleteHide()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        self.dismiss(animated: true , completion: nil)
    }
}



extension HomeActivityView {
    public func configure(with index: Int, width : CGFloat, height : CGFloat) {
        
        let scale = width / height
        
        var imageWidth : CGFloat = 0.0
        var imageHeight : CGFloat = 0.0
        
        if width < screenWidth - 40 && height < screenHeight {
            imageWidth = width
            imageHeight = height
        }else {
            imageWidth = screenWidth - 40
            imageHeight = imageWidth / scale
        }
        
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
        }
        
        if index == 1{
           setLabelAttributedStr()
        }
        
        self.addSubview(deleteBut)
        
        deleteBut.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.width.height.equalTo(30)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
    }
    
    public func setLabelAttributedStr(){
        
        imageView.addSubview(titlelLabel)
        imageView.addSubview(detailLabel)
        
        titlelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).offset(130 * defaultScale)
            make.centerX.equalTo(imageView)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titlelLabel.snp.bottom).offset(10 * defaultScale)
            make.centerX.equalTo(imageView)
        }
        
        let bonusNumberAttributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let titlelLabel1 = NSAttributedString.init(string: "您还有", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let titlelLabel2 = NSAttributedString.init(string: " \(activityModel[1].bonusNumber) ", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        let titlelLabel3 = NSAttributedString.init(string: "张优惠券", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        bonusNumberAttributedStrM.append(titlelLabel1)
        bonusNumberAttributedStrM.append(titlelLabel2)
        bonusNumberAttributedStrM.append(titlelLabel3)
        
        let bonusPriceAttributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let bonusPriceLabel1 = NSAttributedString.init(string: "价值", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        
        let bonusPriceLabel2 = NSAttributedString.init(string: " \(activityModel[1].bonusPrice) ", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)])
        
        let bonusPriceLabel3 = NSAttributedString.init(string: "元\n即将过期", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear , NSAttributedString.Key.foregroundColor : UIColor.red , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        bonusPriceAttributedStrM.append(bonusPriceLabel1)
        bonusPriceAttributedStrM.append(bonusPriceLabel2)
        bonusPriceAttributedStrM.append(bonusPriceLabel3)
        
        
        titlelLabel.attributedText = bonusNumberAttributedStrM
        detailLabel.attributedText = bonusPriceAttributedStrM
    }

    
    
}
// MARK: - 初始化页面
extension HomeActivityView {
    private func initSubview() {
        
    }
}
