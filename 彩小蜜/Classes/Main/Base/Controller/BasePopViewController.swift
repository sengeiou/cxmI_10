//
//  BasePopViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum PopViewStyle {
    case fromCenter
    case fromBottom
    case fromTop
}

class BasePopViewController: UIViewController {

    public var popStyle : PopViewStyle = .fromCenter{
        didSet{
            switch popStyle {
            case .fromCenter:
                initCenterLayout()
            case .fromBottom:
                initBottomLayout()
            case .fromTop:
                initTopLayout()
            }
        }
    }
    
    public var pushBgView : UIView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor(white: 0.3, alpha: 0.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPushBgView()
    }
    
    private func initPushBgView() {
        pushBgView = UIView()
        
        pushBgView.backgroundColor = ColorFFFFFF
    
        self.view.addSubview(pushBgView)
    }
    
    private func initCenterLayout() {
        pushBgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(pushBgView.snp.width)
        }
    }
    
    private func initBottomLayout() {
        pushBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(300)
        }
    }

    private func initTopLayout() {
        pushBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(300)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
