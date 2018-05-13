//
//  MyCollectionVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"

class MyCollectionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var collectModel: NewsListModel!
    private var collectList : [NewsInfoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 我的收藏"
        setRightButton()
        setEmpty(title: "暂无收藏", tableView)
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

        collectionRequest(1)
    }
    
    // MARK: - 网络请求
    private func collectionRequest(_ pageNum: Int) {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectList(pageNum: pageNum))
            .asObservable()
            .mapObject(type: NewsListModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                weakSelf?.collectModel = data
                if pageNum == 1{
                    weakSelf?.collectList.removeAll()
                }
                weakSelf?.collectList.append(contentsOf: data.list)
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
    private func collectionDeleteRequest(collectId: String, indexPath: IndexPath) {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectDelete(collectId: collectId))
        .asObservable()
        .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.showHUD(message: data.msg)
                weakSelf?.collectList.remove(at: indexPath.row)
                weakSelf?.tableView.deleteRows(at: [indexPath], with: .fade)
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
        guard self.collectList != nil else { return }
        let web = NewsDetailViewController()
        web.articleId = self.collectList[indexPath.row].articleId
        pushViewController(vc: web)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.isEditing = false
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
    
    func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "确认删除"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
//            collectList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            collectionDeleteRequest(collectId: collectList[indexPath.row].articleId, indexPath: indexPath)
        }
    }
    
    @objc private func editingClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.tableView.isEditing = sender.isSelected
    }
    
    private func setRightButton() {
        let but = UIButton(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        but.setTitle("编辑", for: .normal)
        but.setTitle("取消", for: .selected)
        but.setTitleColor(Color787878, for: .normal)
        but.addTarget(self, action: #selector(editingClicked(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
