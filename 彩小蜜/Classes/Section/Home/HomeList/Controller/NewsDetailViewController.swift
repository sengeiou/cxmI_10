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


class NewsDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NewsDetailCellDelegate, NewsDetailFooterDelegate {
    
    
    
    
    // MARK: - 属性 public
    public var newsInfo : NewsInfoModel!
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
    private var cellHeight : CGFloat = 50
    private var footer : NewsDetailFooter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 资讯"
        newsDetailRequest()
        setRightItem()
        initSubview()
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
        content.urlStr = self.detailModel.link
        content.sharePic = UIImage(named:"Racecolorfootball")
        
        let share = ShareViewController()
        share.shareContent = content
        present(share)
    }
    // 查看更多
    func didTipLookMore() {
        let recom = NewsRecommendVC()
        recom.articleId = newsInfo.articleId
        pushViewController(vc: recom)
    }
    // MARK: - delegate
    // 更新cell 高度
    func upDateCellHeight(height: CGFloat) {
        
        //tableView.rowHeight = 1000
        self.cellHeight = height
        tableView.beginUpdates()
        tableView.endUpdates()
        
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
    }
    
    private func initSubview() {
        
        self.view.addSubview(tableView)
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
        _ = homeProvider.rx.request(.newsDetail(articleId: newsInfo.articleId))
        .asObservable()
        .mapObject(type: NewsDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.detailModel = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func addCollectRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectAdd(articledId: newsInfo.articleId, articleTitle: newsInfo.title, collectFrom: ""))
            .asObservable()
            .mapObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.showHUD(message: data.msg)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    private func deleteCollectRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectDelete(collectId: newsInfo.articleId))
            .asObservable()
            .mapObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.showHUD(message: data.msg)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
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
        
        let footer = NewsDetailFooter()
        footer.delegate = self
        table.tableFooterView = footer
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return 1
        }else {
            guard self.detailModel != nil, self.detailModel.articles != nil else { return 0 }
            return self.detailModel.articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section ==  0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsDetailCellId, for: indexPath) as! NewsDetailCell
            cell.detailInfo = self.detailModel
            cell.delegate = self
            
            return cell
        }else {
            let newsInfo = self.detailModel.articles[indexPath.row]
            
            if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                return initNewsOnePicCell(indexPath: indexPath)
            }else if newsInfo.listStyle == "3" {
                return initNewsThreePicCell(indexPath: indexPath)
            }else {
                return initNewsNoPicCell(indexPath: indexPath)
            }
        }
        
        return UITableViewCell()
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCellId, for: indexPath) as! NewsNoPicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row]
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCellId, for: indexPath) as! NewsThreePicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row]
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCellId, for: indexPath) as! NewsOnePicCell
        cell.newsInfo = self.detailModel.articles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return cellHeight
        }else {
            let newsInfo = self.detailModel.articles[indexPath.row]
            
            if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                return 110 * defaultScale
            }
            else {
                return 140 * defaultScale
            }
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
        // Dispose of any resources that can be recreated.
    }
    

   

}
