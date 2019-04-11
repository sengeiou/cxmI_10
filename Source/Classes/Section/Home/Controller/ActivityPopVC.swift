//
//  ActivityPopVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

protocol ActivityPopVCDelegate {
    func didTipActivity(link : String) -> Void
}

class ActivityPopVC: UIViewController {

    public var delegate : ActivityPopVCDelegate!
    
    lazy var deleteBut : UIButton = {
        let but = UIButton(type: .custom)
//        but.setImage(UIImage(named: "关闭"), for: .normal)
        but.setBackgroundImage(UIImage(named: "关闭"), for: .normal)
        but.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return but
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    lazy public var imageView : UIImageView = {
        var imageView = UIImageView()
//        imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTipImageView))
        
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
}

// MARK: - 点击事件
extension ActivityPopVC {
    @objc private func didTipImageView() {
        guard delegate != nil else { return }
        delegate.didTipActivity(link: "")
    }
    
    @objc private func deleteClicked() {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true , completion: nil)
    }
}
extension ActivityPopVC {
    public func configure(with width : CGFloat, height : CGFloat) {
        
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
        
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.width.equalTo(imageWidth)
            
            make.height.equalTo(imageHeight)
        }
        
        self.view.addSubview(deleteBut)
        
        deleteBut.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.width.height.equalTo(30)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
    }
    
    
}
// MARK: - 初始化页面
extension ActivityPopVC {
    private func initSubview() {
        
    }
    
    
    
}
