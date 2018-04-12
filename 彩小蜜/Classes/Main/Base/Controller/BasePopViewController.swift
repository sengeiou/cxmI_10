//
//  BasePopViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


enum PopViewStyle {
    case fromCenter
    case fromBottom
    case fromTop
}

class BasePopViewController: UIViewController, AlertPro, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    public var popStyle : PopViewStyle = .fromCenter{
        didSet{
            switch popStyle {
            case .fromCenter:
                initCenterLayout()
            case .fromBottom: break
//                initBottomLayout()
            case .fromTop:
                initTopLayout()
            }
        }
    }
    
    public var viewHeight : CGFloat! {
        didSet{
            switch popStyle {
            case .fromBottom:
                initBottomLayout(height: viewHeight)
            default: break
                
            }
        }
    }
    public var pushBgView : UIView!
    
    private var emptyTitle: String!
    
    public func setEmpty(title: String, _ tableView: UITableView) {
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        self.emptyTitle = title
    }
    
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
            make.width.equalTo(326 * defaultScale)
            make.height.equalTo(266 * defaultScale)
        }
    }
    
    private func initBottomLayout(height : CGFloat) {
        pushBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(height)
        }
    }

    private func initTopLayout() {
        pushBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(300)
        }
    }
    
    
    
    
    //MARK: - 空列表视图
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let att = NSAttributedString(string: emptyTitle, attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0, NSAttributedStringKey.font: Font15])
        return att
    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return ColorF4F4F4
    }
//    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//        return -80
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
