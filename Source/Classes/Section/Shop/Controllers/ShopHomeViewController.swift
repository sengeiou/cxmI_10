//
//  ShopHomeViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ShopHomeViewController: BaseViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    
    private var pageModel : BasePageModel<GoodsListModel>!
    
    private var bannerList : [BannerModel] = [BannerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商城"
        hideBackBut()
        setupCollectionView()
        
        collectionView.headerRefresh {
            self.loadNewData()
        }
        collectionView.footerRefresh {
            self.loadNextData()
        }
        collectionView.beginRefreshing()
        goodsBannerRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }
    private func setupCollectionView() {
        collectionView.register(ShopBannerItem.self, forCellWithReuseIdentifier: ShopBannerItem.identifier)
    }
}
// MARK: - 点击事件，代理
extension ShopHomeViewController : UICollectionViewDelegate, BannerViewDelegate {
    
    func didTipBanner(banner: BannerModel) {
        pushRouterVC(urlStr: banner.bannerLink, from: self)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = pageModel.list[indexPath.row]
        let story = UIStoryboard(storyboard: .Shop)
        let detail = story.instantiateViewController(withIdentifier: "CommodityDetailsVC") as! CommodityDetailsVC
        detail.goodsId = model.goodsId
        pushViewController(vc: detail)
    }
}
// MARK: - COLLECTION DataSource
extension ShopHomeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard pageModel != nil else { return 0}
            guard pageModel.list != nil else { return 0}
            return pageModel.list.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopBannerItem.identifier, for: indexPath) as! ShopBannerItem
            cell.bannerView.delegate = self
            cell.configure(with: bannerList)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItem.identifier, for: indexPath) as! ShopItem
            let goods = pageModel.list[indexPath.row]
            cell.configure(with: goods)
            return cell
        }
    }
}

extension ShopHomeViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: 180)
        default:
            return CGSize(width: ShopItem.width, height: ShopItem.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: ShopItem.spacing, bottom: 0, right: ShopItem.spacing)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ShopItem.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ShopItem.spacing / 2
    }
}

// MARK: - 网络请求
extension ShopHomeViewController {
    
    //MARK: - 加载数据
    private func loadNewData() {
        //configRequest()
        goodsListRequest(page: 1)
    }
    private func loadNextData() {
        guard self.pageModel != nil else { return }
        guard self.pageModel.isLastPage == false else {
            self.collectionView.noMoreData()
            return }
        goodsListRequest(page: self.pageModel.nextPage)
    }
    
    private func goodsListRequest(page : Int) {
        weak var weakSelf = self
        
        _ = shopProvider.rx.request(.goodsList(page: page)).asObservable()
            .mapObject(type: BasePageModel<GoodsListModel>.self)
            .subscribe(onNext: { (data) in
                weakSelf?.collectionView.endrefresh()
                weakSelf?.pageModel = data
                weakSelf?.collectionView.reloadData()
            }, onError: { (error) in
                weakSelf?.collectionView.endrefresh()
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
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func goodsBannerRequest() {
        weak var weakSelf = self
        _ = shopProvider.rx.request(.bannerList).asObservable()
            .mapObject(type: GoodsBanner.self)
            .subscribe(onNext: { (data) in
                weakSelf?.bannerList = data.bannerList
            }, onError: { (error) in
                weakSelf?.collectionView.endrefresh()
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
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
