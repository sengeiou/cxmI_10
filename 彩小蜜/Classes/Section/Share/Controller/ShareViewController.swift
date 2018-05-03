//
//  ShareViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let ShareCellId = "ShareCellId"

fileprivate let topInset : CGFloat = 33 * defaultScale
fileprivate let leftInset : CGFloat = 37 * defaultScale
fileprivate let minimumLineSpacing : CGFloat = 10
fileprivate let minimumInteritemSpacing : CGFloat = 20 * defaultScale
fileprivate let cellWidth : CGFloat = (screenWidth - leftInset * 2 - minimumInteritemSpacing * 4) / 4
fileprivate let cellHeight : CGFloat = 70 * defaultScale

class ShareViewController: BasePopViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WeixinSharePro {
    
    public var shareContent: ShareContentModel!

    // MARK: - 属性 private
    private var bottomLine : UIView!
    private var cancelBut: UIButton!
    private var shareList: [ShareDataModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeixinCenter.share.shareDelegate = self
        self.popStyle = .fromBottom
        
        shareList = ShareDataManager.share.getShardList()
        
        initSubview()
    }
    
    @objc private func cancelClicked(_ sender: UIButton) {
        
    }
    
    //MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shareData = shareList[indexPath.row]
        share(with: shareData.shareCode)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

    private func share(with shareCode: ShareCode) {
        switch shareCode {
        case .ShareWeixin:
            shareWeixin()
        case .ShareWeixinCircle:
            shareWeixinCircle()
        case .ShareLink:
            shareLink()
        default: break
        }
    }
    
    private func shareWeixin() {
        guard shareContent != nil else { return }
        shareImage(content: self.shareContent, scene: WXSceneSession)
    }
    private func shareWeixinCircle() {
        guard shareContent != nil else { return }
        shareImage(content: self.shareContent, scene: WXSceneTimeline)
    }
    private func shareLink() {
        guard self.shareContent.urlStr != nil else { return }
        let paseboard = UIPasteboard.general
        paseboard.string = self.shareContent.urlStr
        showHUD(message: "复制连接成功")
    }
    
    // MARK: - 分享 delegate
    func onShardWeixin(response: SendMessageToWXResp) {
        switch response.errCode {
        case 0:
            showHUD(message: "分享成功")
        case WXErrCodeCommon.rawValue:
            showHUD(message: "分享失败，请稍后重试")
        case WXErrCodeSentFail.rawValue:
            showHUD(message: "分享失败，请稍后重试")
        case WXErrCodeUserCancel.rawValue:
            showHUD(message: "取消分享")
        case WXErrCodeUnsupport.rawValue:
            showHUD(message: "分享失败，不支持的分享类型")
        case WXErrCodeAuthDeny.rawValue:
            showHUD(message: "分享失败，请稍后重试")
            
        default:
            break
        }
    }
    
    // MARK: - 网络请求
    private func shareRequest() {
        
    }
    override func viewDidLayoutSubviews() {
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(-36 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        cancelBut.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
        }
    }

    private func initSubview() {
        self.viewHeight = 160 * defaultScale
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        cancelBut = UIButton(type: .custom)
        cancelBut.setTitle("取消", for: .normal)
        cancelBut.setTitleColor(Color505050, for: .normal)
        cancelBut.titleLabel?.font = Font13
        cancelBut.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
        
        self.pushBgView.addSubview(bottomLine)
        self.pushBgView.addSubview(cancelBut)
        self.pushBgView.addSubview(collectionView)
    }
    
    // MARK: - 懒加载
    lazy public var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = ColorFFFFFF
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = true
        collection.isScrollEnabled = false
        collection.register(ShareCell.self, forCellWithReuseIdentifier: ShareCellId)
        return collection
    }()
    
    // MARK: - COLLECTION DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard shareList != nil else { return 0 }
        return shareList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareCellId, for: indexPath) as! ShareCell
        
        cell.shareData = self.shareList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
