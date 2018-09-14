//
//  BaseViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SnapKit
import DZNEmptyDataSet
import SVProgressHUD
import Reachability
import JPImageresizerView


class BaseViewController: UIViewController, AlertPro, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, DateProtocol, UserInfoPro , LoginProtocol, RouterPro, LineNumberProtocol{
    func didLogin(isLogin: Bool) {
        
    }
    
    public var popRoot : Bool = false
    // public
    public var currentVC : UIViewController? {
        didSet{
            
        }
    }
    
    public func pushLoginVC(from vc: UIViewController) {
//        let login = LoginViewController()
//        login.currentVC = vc
//        login.loginDelegate = vc as! LoginProtocol
//        self.navigationController?.pushViewController(login, animated: true)
        
        let login = CXMVCodeLoginViewController()
        login.currentVC = vc
        login.loginDelegate = vc as! LoginProtocol
        
        pushViewController(vc: login)
    }
    public func pushLoginVC(from vc : UIViewController, fromWeb : Bool) {
        let login = CXMVCodeLoginViewController()
        login.fromWeb = fromWeb
        login.currentVC = vc
        login.loginDelegate = vc as! LoginProtocol
        
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    public func pushPagerView(pagerType: PagerViewType) {
        
        
        let storyboard = UIStoryboard(name: "Storyboard", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "BasePagerViewController") as! BasePagerViewController
        vc.pagerType = pagerType
        pushViewController(vc: vc)
    }
    
    public func pushViewController(vc: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    public func pushWebViewController(url: String) {
        let web = CXMActivityViewController()
        web.urlStr = url
        self.navigationController?.pushViewController(web, animated: true)
    }
    public func pushRootViewController() {
        pushRootViewController(0)
    }
    public func pushRootViewController(_ index: Int) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let root = MainTabBarController()
        root.selectedIndex = index
        window.rootViewController = root
    }
    
    public func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    public func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    public func popToCurrentVC() {
        for vc in (self.navigationController?.viewControllers)! {
            if currentVC != nil, vc == currentVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    public func popToHome() {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.tabBarController?.selectedIndex = 0
    }
    public func popToVCodeLoginViewController() {
        guard self.navigationController?.viewControllers != nil else { return }
        for vc in (self.navigationController?.viewControllers)! {
            if vc .isKind(of: CXMVCodeLoginViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    public func popToLoginViewController() {
        guard self.navigationController?.viewControllers != nil else { return }
        for vc in (self.navigationController?.viewControllers)! {
            if vc .isKind(of: CXMLoginViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    public func present(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    public func hideBackBut() {
        self.navigationItem.leftBarButtonItem = nil
    }
    public func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    public func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    public func setEmpty(title: String, _ tableView: UITableView) {
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        self.emptyTitle = title
    }
    public func setEmpty(title: String, _ collectionView: UICollectionView) {
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        self.emptyTitle = title
    }
    public func showProgressHUD() {
        SVProgressHUD.show()
    }
    public func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    //MARK: - 属性
    public var addPanGestureRecognizer = true {
        didSet{
            if addPanGestureRecognizer {
                self.view.addGestureRecognizer(pan)
            }else {
                self.view.removeGestureRecognizer(pan)
            }
        }
    }
    
    private let pan = UIPanGestureRecognizer(target: self, action: nil )
    
    public var isHidenBar : Bool! {
        didSet{
            guard isHidenBar != nil else { return }
            if isHidenBar == true {
                hideTabBar()
            }else {
                showTabBar()
            }
        }
    }
    
    private var emptyTitle: String!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorF4F4F4
        setNavigation()
        self.isHidenBar = true
        
        addPanGestureRecognizer = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font17, NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        
        setLiftButtonItem()
        
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
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -80
    }
    
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setLiftButtonItem() {
        
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc func back(_ sender: UIButton) {
        popViewController()
        
        self.dismissProgressHud()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
