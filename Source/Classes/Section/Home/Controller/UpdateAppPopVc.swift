//
//  UpdateAppPopVc.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/4/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

protocol UpdateAppPopVcDelegate {
    func didTipUpdateApp(link : String) -> Void
}


class UpdateAppPopVc: UIViewController {
    
    public var delegate : UpdateAppPopVcDelegate!
    
    lazy public var deleteBut : UIButton = {
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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTipImageView))
        
//        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy public var titleLabel : UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "发现现版本"
        titleLabel.font = Font24
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    lazy public var detailLabel : UILabel = {
        var detailLabel = UILabel()
        detailLabel.text = ""
        detailLabel.font = Font20
        detailLabel.textColor = .white
        return detailLabel
    }()
    
    lazy public var scroll : UIScrollView = {
        var scroll = UIScrollView()
        return scroll
    }()

    lazy public var updateButton : UIButton = {
        var updateButton = UIButton()
        updateButton.setTitle("立即更新", for: .normal)
        updateButton.backgroundColor = UIColor(hexColor: "ea5504")
        updateButton.layer.cornerRadius = 4
        updateButton.layer.masksToBounds = true
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.addTarget(self, action: #selector(didTipImageView), for: .touchUpInside)
        return updateButton
    }()
    
}


extension UpdateAppPopVc {
    @objc private func didTipImageView() {
        guard delegate != nil else { return }
        delegate.didTipUpdateApp(link: "")
    }
    
    @objc private func deleteClicked() {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        self.dismiss(animated: true , completion: nil)
    }
    
}

extension UpdateAppPopVc {
    public func configure(version: String?) {

        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.height.equalTo(400)
        }
        
        imageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView).offset(18)
            make.top.equalTo(imageView).offset(56)
        }
        
        imageView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        detailLabel.text =  "v" + version!
        
        self.view.addSubview(deleteBut)
        deleteBut.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.width.height.equalTo(30)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
        imageView.addSubview(scroll)
        scroll.snp.makeConstraints { (make) in
            make.left.equalTo(imageView).offset(18)
            make.right.equalTo(imageView).offset(-18)
            make.top.equalTo(detailLabel.snp.bottom).offset(50)
            make.bottom.equalTo(imageView).offset(-60)
        }
        
        imageView.addSubview(updateButton)
        updateButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
    }
    

    public func configureList(list:[String]){
        var labelArr : [UILabel] = []
        for i in 0..<list.count{
            let label = UILabel()
            label.font = Font16
            label.textColor = .black
            label.numberOfLines = 0
            scroll.addSubview(label)
            labelArr.append(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(detailLabel)
                make.right.equalTo(imageView).offset(-18)
                make.top.equalTo(scroll).offset((i + 1) * 30)
            }
            label.text = "\(i + 1). " + "\(list[i])"
        }
        
        
        let lastLabel = labelArr.last
        self.view.layoutIfNeeded()
        scroll.contentSize = CGSize(width: 0, height: (lastLabel?.frame.maxY)!)
    }
    
    
}

// MARK: - 初始化页面
extension UpdateAppPopVc {
    private func initSubview() {
        
    }
}

