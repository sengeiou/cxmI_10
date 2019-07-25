//
//  HomeSuspendedView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/7/12.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

private let ScreenHeight = UIScreen.main.bounds.size.height
private let ScreenWidth = UIScreen.main.bounds.size.width
private let cornerRadio:CGFloat = 30.0
private let placeWidth = 5.0
private let centerX:CGFloat = 30.0  //x半径
private let centerY:CGFloat = 30.0  //y半径

protocol HomeSuspendedViewDelegate {
    func clickSuspendedBallBtn(urlStr: String) -> Void
}

class HomeSuspendedView: UIView, UIGestureRecognizerDelegate {
    enum SuspendedBallLocation:Int {
        case SuspendedBallLocation_LeftTop = 0
        case SuspendedBallLocation_Top
        case SuspendedBallLocation_RightTop
        case SuspendedBallLocation_Right
        case SuspendedBallLocation_RightBottom
        case SuspendedBallLocation_Bottom
        case SuspendedBallLocation_LeftBottom
        case SuspendedBallLocation_Left
    }

    static public let singleHomeSuspendedView = HomeSuspendedView()
    private var ballBtn:UIButton?
    private var timeLable:UILabel?
    private var currentCenter:CGPoint?
    private var panEndCenter:CGPoint = CGPoint(x: 0, y: 0)
    private var currentLocation: SuspendedBallLocation?
    
    public var delegate: HomeSuspendedViewDelegate!
    
    
    //悬浮框模型
    public var suspendedModel : ActivityModel!{
        didSet{
            guard suspendedModel != nil else { return }
            let btn = self.getBallBtn()
            let url = URL(string : suspendedModel.bannerImage)
            let imageV = UIImageView()
            imageV.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                btn.setImage(image, for: .normal)
            }
        }
    }
    
    
    //MARK:- init method
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(2 * centerX), height: CGFloat(2 * centerY)))
        
        self.addSubview(self.getBallBtn())
        self.backgroundColor = .clear
        self.currentCenter = CGPoint.init(x:screenWidth - 40 * defaultScale, y: screenHeight - (100 * defaultScale) - (CGFloat(2 * centerY))) //初始位置
        self.calculateShowCenter(point: self.currentCenter!)
        self.configLocation(point: self.currentCenter!)
        
        //跟随手指拖动
        let moveGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragBallView))
        self.addGestureRecognizer(moveGes)
        //添加到window上
        self.getKeyWindow().addSubview(self)
        //显示在视图的最上层
        self.getKeyWindow().bringSubviewToFront(self)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit{
        NSLog("SuspendedBallView deinit")
    }


    
    //跟随手指拖动
    @objc func dragBallView(panGes:UIPanGestureRecognizer) {
        let translation:CGPoint = panGes.translation(in: self.getKeyWindow())
        let center:CGPoint = self.center
        self.center = CGPoint( x: center.x+translation.x,  y: center.y+translation.y)
        panGes .setTranslation(CGPoint( x: 0,  y: 0), in: self.getKeyWindow())
        if panGes.state == UIGestureRecognizer.State.ended{
            self.panEndCenter = self.center
            self.caculateBallCenter()
        }
    }
    
    //计算中心位置 上下左右
    func caculateBallCenter() {
        if (self.panEndCenter.x>centerX && self.panEndCenter.x < ScreenWidth-centerX && self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY) {
            if (self.panEndCenter.y<3*centerY) {
                self.calculateBallNewCenter(point: CGPoint( x: self.panEndCenter.x,  y: centerY))
            }
            else if (self.panEndCenter.y>ScreenHeight-3*centerY)
            {
                self.calculateBallNewCenter(point: CGPoint( x: self.panEndCenter.x, y:  ScreenHeight-centerY))
            }
            else
            {
                if (self.panEndCenter.x<=ScreenWidth/2) {
                    self.calculateBallNewCenter(point: CGPoint( x: centerX,  y: self.panEndCenter.y))
                }
                else{
                    self.calculateBallNewCenter(point: CGPoint( x: ScreenWidth-centerX,  y: self.panEndCenter.y))
                }
            }
        }
        else
        {
            if (self.panEndCenter.x<=centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX,  y: centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX,  y: centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX,  y: ScreenHeight-centerY))
            }
            else if(self.panEndCenter.x<=centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX,  y: ScreenHeight-centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y<centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x,  y: centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y>ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x,  y: ScreenHeight-centerY))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x<centerX)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX, y: self.panEndCenter.y))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x>ScreenWidth-centerX)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX, y: self.panEndCenter.y))
            }
        }
        
    }
    
    //
    func calculateBallNewCenter(point:CGPoint) {
        self.currentCenter = point
        self.configLocation(point: point)
        unowned let weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf.center = CGPoint(x: point.x, y: point.y)
        }
    }
    
    func calculateShowCenter(point:CGPoint) {
        unowned let weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf.center = CGPoint(x: point.x, y: point.y)
        }
    }
    
    //当前方位
    func configLocation(point:CGPoint) {
        if (point.x <= centerX*3 && point.y <= centerY*3) {
            self.currentLocation = .SuspendedBallLocation_LeftTop;
        }
        else if (point.x>centerX*3 && point.x<ScreenWidth-centerX*3 && point.y == centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Top;
        }
        else if (point.x >= ScreenWidth-centerX*3 && point.y <= 3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightTop;
        }
        else if (point.x == ScreenWidth-centerX && point.y>3*centerY && point.y<ScreenHeight-centerY*3)
        {
            self.currentLocation = .SuspendedBallLocation_Right;
        }
        else if (point.x >= ScreenWidth-3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightBottom;
        }
        else if (point.y == ScreenHeight-centerY && point.x > 3*centerX && point.x<ScreenWidth-3*centerX)
        {
            self.currentLocation = .SuspendedBallLocation_Bottom;
        }
        else if (point.x <= 3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_LeftBottom;
        }
        else if (point.x == centerX && point.y > 3*centerY && point.y<ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Left;
        }
    }
    
    //单列获取悬浮起按钮
    func getBallBtn() -> UIButton {
        if ballBtn == nil {
            ballBtn = UIButton.init(type: .custom)
            ballBtn?.frame = CGRect(x: 0, y: 0, width: CGFloat(2 * centerX), height: CGFloat(2 * centerY))
            ballBtn?.layer.masksToBounds = true
            ballBtn?.layer.cornerRadius = cornerRadio
            ballBtn?.addTarget(self, action: #selector(clickBallViewAction), for: .touchUpInside)
        }
        return ballBtn!
    }
    
    //MARK:- action
    @objc func clickBallViewAction() {
        guard delegate != nil else { return }
        delegate.clickSuspendedBallBtn(urlStr: self.suspendedModel.bannerLink)
    }
    
    //MARK:- private utility
    func getKeyWindow() -> UIWindow {
        if UIApplication.shared.keyWindow == nil {
            return ((UIApplication.shared.delegate?.window)!)!
        }else{
            return UIApplication.shared.keyWindow!
        }
    }
}
