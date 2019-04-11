//
//  SellerDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class SellerDetailVC: BaseViewController {

    public var storeId : String!
    @IBOutlet weak var sellerName : UILabel!
    @IBOutlet weak var qrCode : UIImageView!
    @IBOutlet weak var weChat : UILabel!
    @IBOutlet weak var contactBut : UIButton!
    @IBOutlet weak var licence : UIButton! // 许可证
    
    private var detailModel : SellerDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "店铺详情"
        initSubview()
        detailRequest()
    }
    
    private func initSubview() {
        self.contactBut.layer.cornerRadius = 5
        self.contactBut.layer.masksToBounds = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
        longPress.numberOfTapsRequired = 0 //默认为0
        longPress.numberOfTouchesRequired = 1  //默认为1
        
        qrCode.addGestureRecognizer(longPress)
        qrCode.isUserInteractionEnabled = true
        
        let copyLongPress = UILongPressGestureRecognizer(target: self, action: #selector(copyWechat))
        
        weChat.addGestureRecognizer(copyLongPress)
        weChat.isUserInteractionEnabled = true
    }
}

// MARK: - 点击事件
extension SellerDetailVC : SaveImageProtocol {
    // 许可证
    @IBAction func licenceClicked(_ sender: UIButton) {
        guard let url = URL(string: detailModel.bizPermitUrl) else { return }
        
        let activity = ActivityPopVC()
        activity.imageView.kf.setImage(with: url, placeholder: nil, options: nil , progressBlock: nil) { (image, error, type , url) in
            guard let img = image else { return }
            activity.configure(with: img.size.width, height: img.size.height)
            self.present(activity)
        }
    }
    // 联系店主
    @IBAction func contactClicked(_ sender: UIButton) {
        pushRouterVC(urlStr: detailModel.jumpUrl, from: self)
    }
    // 长按保存图片到本地
    @objc private func saveImage() {
        if let image = qrCode.image {
            showCXMAlert(title: nil, message: "是否保存图片到本地", action: "是", cancel: "否") { (action) in
                self.saveToPhotosAlbum(with: image)
            }
        }
    }
    // 长按复制微信号
    @objc private func copyWechat() {
        guard detailModel != nil else { return }
        let paseboard = UIPasteboard.general
        
        paseboard.string = detailModel.wechat
        
        showHUD(message: "复制成功")
    }
    
    public func saveToPhotosAlbum(with image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }else{
            showMessage = "保存成功"
            self.dismiss(animated: true, completion: nil)
        }
        showHUD(message: showMessage)
    }
}

extension SellerDetailVC {
    private func setupDataInfo() {
        if let url = URL(string: detailModel.imgWechat) {
            self.qrCode.kf.setImage(with: url)
        }
        self.sellerName.text = detailModel.name
        self.weChat.text = "店主微信:" + detailModel.wechat
    }
}
// MARK: - 网络请求
extension SellerDetailVC {
    private func detailRequest() {
        weak var weakSelf = self
        _ = sellerProvider.rx.request(.sellerDetail(shopId: storeId)).asObservable()
            .mapObject(type: SellerDetailModel.self)
            .subscribe(onNext: { (data) in
                self.detailModel = data
                self.setupDataInfo()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
