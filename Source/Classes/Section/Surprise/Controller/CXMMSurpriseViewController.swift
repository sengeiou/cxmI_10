//
//  TTMSurpriseViewController.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum SurpriseType : String {
    case 今日关注 = "今日关注"
    case 重心推荐 = "重心推荐"
    case 牛人分析 = "牛人分析"
    case 其它 = "其它"
}

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"

class CXMMSurpriseViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource , IndicatorInfoProvider{

    public var type : SurpriseType = .今日关注 {
        didSet{
            
        }
    }
    
    private var collectModel: NewsListModel!
    private var collectList : [NewsInfoModel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "天空体育 · 我的收藏"
        //setRightButton()
       
        setEmpty(title: "暂无内容", tableView)
        collectList = [NewsInfoModel]()
        collectionRequest(1)
        initSubview()
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideBackBut()
        isHidenBar = false
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: type.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-SafeAreaBottomHeight)
        }
    }
    
    private func initSubview() {
        self.view.addSubview(tableView)
        
    }
    
    //MARK: - 加载数据
    private func loadNewData() {
        collectionRequest(1)
    }
    private func loadNextData() {
        guard self.collectModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        collectionRequest(self.collectModel.nextPage)
    }
    
    // MARK: - 网络请求
    private func collectionRequest(_ pageNum: Int) {
        self.showProgressHUD()
        weak var weakSelf = self
        
        var cat = ""
        switch type {
        case .今日关注:
            cat = "1"
        case .重心推荐:
            cat = "2"
        case .牛人分析:
            cat = "3"
        case .其它:
            cat = "4"
        
        }
        
        _ = userProvider.rx.request(.surprise(page: pageNum, extendCat: cat))
            .asObservable()
            .mapObject(type: SurpriseModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                weakSelf?.collectModel = data.dlArticlePage
                if pageNum == 1{
                    weakSelf?.collectList.removeAll()
                }
            
                weakSelf?.collectList.insert(contentsOf: data.bigNewsList, at: 0)
                
                //weakSelf?.collectList.append(contentsOf: data.bigNewsList)
                weakSelf?.collectList.append(contentsOf: data.dlArticlePage.list)
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.collectList != nil else { return }
        let web = CXMNewsDetailViewController()
        web.articleId = self.collectList[indexPath.section].articleId
        pushViewController(vc: web)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.isEditing = false
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        table.register(SurpriseTableViewCell.self, forCellReuseIdentifier: SurpriseTableViewCell.identifier)
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard collectList.isEmpty == false else { return 0 }
        return collectList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsInfo = collectList[indexPath.section]
        
        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
            return initNewsOnePicCell(indexPath: indexPath)
        }else if newsInfo.listStyle == "3" {
            return initNewsThreePicCell(indexPath: indexPath)
        }
        else if newsInfo.listStyle == "5" {
            return initBigCell(indexPath: indexPath)
        }
        else {
            return initNewsNoPicCell(indexPath: indexPath)
        }
    }
    
    private func initBigCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurpriseTableViewCell.identifier, for: indexPath) as! SurpriseTableViewCell
        
        let urlStr = self.collectList[indexPath.section].articleThumb[0]
        
        cell.configure(with: urlStr)
       
        return cell
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCellId, for: indexPath) as! NewsNoPicCell
        cell.newsInfo = self.collectList[indexPath.section]
        cell.bottomLine.isHidden = true
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCellId, for: indexPath) as! NewsThreePicCell
        cell.newsInfo = self.collectList[indexPath.section]
        cell.bottomLine.isHidden = true
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCellId, for: indexPath) as! NewsOnePicCell
        cell.newsInfo = self.collectList[indexPath.section]
        cell.bottomLine.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let newsInfo = collectList[indexPath.section]
        
        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
            return 110 * defaultScale
        }
        else {
            return 140 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 8
        default:
            return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

}
