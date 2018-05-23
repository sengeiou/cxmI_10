//
//  NewsDetailViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

fileprivate let NewsDetailCellId = "NewsDetailCellId"

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"
fileprivate let NewsDeatilTitleCellId = "NewsDeatilTitleCellId"

class NewsDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NewsDetailCellDelegate, NewsDetailFooterDelegate {
    
    
    
    
    // MARK: - 属性 public
    //public var newsInfo : NewsInfoModel!
    public var articleId: String!
    
    // MARK: - 属性 private
    private var detailModel: NewsDetailModel! {
        didSet{
            guard detailModel != nil, detailModel.isCollect != nil else { return }
            if detailModel.isCollect {
                collectBut.isSelected = true
            }else {
                collectBut.isSelected = false
            }
        }
    }
    private var collectBut: UIButton!    // 收藏
    private var shareBut: UIButton!      // 分享
    private var cellHeight : CGFloat = 100
    private var footer : NewsDetailFooter!
    private var webView : WKWebView!
    private var bagView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 资讯详情"
        newsDetailRequest()
        setRightItem()
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //newsDetailRequest()
    }
    
    // MARK: - 点击事件
    // 收藏
    @objc private func collectButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        addOrDeleteCollect(isAdd: sender.isSelected)
    }
    // 分享
    @objc private func shareButClicked(_ sender: UIButton) {
        guard self.detailModel != nil else { return }
        var content = ShareContentModel()
        content.title = self.detailModel.title
        content.description = self.detailModel.summary
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        var turn = "0"
        
        if turnOn {
            turn  = "1"
        }
        
        content.urlStr = self.detailModel.link + "&frz=\(turn)"
        content.sharePic = UIImage(named:"fenxiangtubiao")
        
        let share = ShareViewController()
        share.shareContent = content
        present(share)
    }
    // 查看更多
    func didTipLookMore() {
        let recom = NewsRecommendVC()
        recom.articleId = articleId
        pushViewController(vc: recom)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row != 0 {
                guard self.detailModel != nil else { return }
                let web = NewsDetailViewController()
                web.articleId = self.detailModel.articles[indexPath.row - 1 ].articleId
                pushViewController(vc: web)
            }
        }
    }
    
    // MARK: - delegate
    // 更新cell 高度
    func upDateCellHeight(height: CGFloat) {
        
        //tableView.rowHeight = 1000
        self.cellHeight = height
        tableView.beginUpdates()
        tableView.endUpdates()
        
//        UIView.animate(withDuration: 2) {
//            self.bagView.backgroundColor = UIColor.clear
//        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bagView.backgroundColor = UIColor.clear
        }) { (finish) in
            if finish {
                self.bagView.isHidden = true
            }
        }
    }
    private func addOrDeleteCollect(isAdd: Bool) {
        if isAdd {
            addCollectRequest()
        }else {
            deleteCollectRequest()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        bagView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    private func initSubview() {
        bagView = UIView()
        bagView.backgroundColor = ColorFFFFFF
        
        self.view.addSubview(tableView)
        self.view.addSubview(bagView)
        
        
    }
    
    private func setRightItem() {
        collectBut = UIButton(type: .custom)
        collectBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        collectBut.setImage(UIImage(named: "收藏"), for: .normal)
        collectBut.setImage(UIImage(named: "se收藏"), for: .selected)
        collectBut.addTarget(self, action: #selector(collectButClicked(_:)), for: .touchUpInside)
        
        shareBut = UIButton(type: .custom)
        shareBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        shareBut.setTitle("分享", for: .normal)
        shareBut.setTitleColor(Color9F9F9F, for: .normal)
        shareBut.addTarget(self, action: #selector(shareButClicked(_:)), for: .touchUpInside)
        
        let collectItem = UIBarButtonItem(customView: collectBut)
        let shareItem = UIBarButtonItem(customView: shareBut)
        
        self.navigationItem.rightBarButtonItems = [shareItem, collectItem]
    }
    
    // MARK: - 网络请求
    private func newsDetailRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.newsDetail(articleId: articleId))
        .asObservable()
        .mapObject(type: NewsDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.detailModel = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                        
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func addCollectRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectAdd(articledId: articleId))
            .asObservable()
            .mapObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.showHUD(message: data.msg)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 0:
                        weakSelf?.showHUD(message: msg!)
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                        weakSelf?.collectBut.isSelected = false
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    private func deleteCollectRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectDelete(collectId: articleId))
            .asObservable()
            .mapObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.showHUD(message: data.msg)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 0:
                        weakSelf?.showHUD(message: msg!)
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(NewsDetailCell.self, forCellReuseIdentifier: NewsDetailCellId)
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        table.register(NewsDeatilTitleCell.self, forCellReuseIdentifier: NewsDeatilTitleCellId)
        table.separatorStyle = .none
        
        let footer = NewsDetailFooter()
        footer.delegate = self
        table.tableFooterView = footer
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.detailModel != nil else { return 0 }
        guard self.detailModel.articles != nil, self.detailModel.articles.isEmpty == false else {
            tableView.tableFooterView = nil
            return 1 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return 1
        }else {
            guard self.detailModel != nil, self.detailModel.articles != nil else { return 0 }
            return self.detailModel.articles.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section ==  0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsDetailCellId, for: indexPath) as! NewsDetailCell
            cell.detailInfo = self.detailModel
            cell.delegate = self
            self.webView = cell.webView
            return cell
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsDeatilTitleCellId, for: indexPath) as! NewsDeatilTitleCell
                return cell
            }else {
                let newsInfo = self.detailModel.articles[indexPath.row - 1]
                
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                    return initNewsOnePicCell(indexPath: indexPath)
                }else if newsInfo.listStyle == "3" {
                    return initNewsThreePicCell(indexPath: indexPath)
                }else {
                    return initNewsNoPicCell(indexPath: indexPath)
                }
            }
            
        }
        
        return UITableViewCell()
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCellId, for: indexPath) as! NewsNoPicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row - 1]
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCellId, for: indexPath) as! NewsThreePicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row - 1]
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCellId, for: indexPath) as! NewsOnePicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row - 1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return cellHeight 
        }else {
            
            if indexPath.row == 0 {
                return 55 * defaultScale
            }else {
                let newsInfo = self.detailModel.articles[indexPath.row - 1]
                
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                    return 110 * defaultScale
                }
                else {
                    return 140 * defaultScale
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("getCxmTitle()") { (data, error) in
            if let title = data as? String {
                self.title = title
            }else {
                self.title = webView.title
            }
        }
        
        let model = JSDataModel()
        let jsData = model.toJSONString()
        
        let urlStr = "\(webView.url!)"
        if urlStr.contains("usinfo=1") {
            webView.evaluateJavaScript("actionMessage('\(jsData!)')") { (data, error) in
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            guard self.webView != nil else { return }
            self.webView.setNeedsLayout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
