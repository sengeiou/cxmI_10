//
//  NewsRecommendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"

class CXMNewsRecommendVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var articleId : String!
    
    private var collectModel: NewsListModel!
    private var collectList : [NewsInfoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 更多资讯"
        setEmpty(title: "暂无相关文章", tableView)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
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
        
        weak var weakSelf = self
        
        _ = homeProvider.rx.request(.newsRecommend(articleId: articleId, page: pageNum))
            .asObservable()
            .mapObject(type: NewsListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.collectModel = data
                if pageNum == 1{
                    weakSelf?.collectList.removeAll()
                }
                weakSelf?.collectList.append(contentsOf: data.list)
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
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
        let web = CXMNewsDetailViewController()
        web.articleId = articleId
        pushViewController(vc: web)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard collectList.isEmpty == false else { return 0 }
        return collectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsInfo = collectList[indexPath.row]
        
        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
            return initNewsOnePicCell(indexPath: indexPath)
        }else if newsInfo.listStyle == "3" {
            return initNewsThreePicCell(indexPath: indexPath)
        }else {
            return initNewsNoPicCell(indexPath: indexPath)
        }
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCellId, for: indexPath) as! NewsNoPicCell
        cell.newsInfo = self.collectList[indexPath.row]
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCellId, for: indexPath) as! NewsThreePicCell
        cell.newsInfo = self.collectList[indexPath.row]
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCellId, for: indexPath) as! NewsOnePicCell
        cell.newsInfo = self.collectList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let newsInfo = collectList[indexPath.row]
        
        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
            return 110 * defaultScale
        }
        else {
            return 140 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
