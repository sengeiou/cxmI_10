//
//  CXMOrderDetailPop.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/1.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CXMOrderDetailPop: BasePopViewController {

    var imageView : UIImageView!
    var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popStyle = .fromCenter
        initSubview()
    }

}

extension CXMOrderDetailPop {
    public func configure(with urlStr : String) {
        
        guard let url = URL(string: urlStr) else { return }
        
        imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self](image, error, type, url) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}

extension CXMOrderDetailPop : SaveImageProtocol {
    
    private func initSubview() {
        self.viewHeight = 400
        
        imageView = UIImageView()
        self.pushBgView.addSubview(imageView)
        
        let line = UIView()
        line.backgroundColor = ColorEDEDED
        self.pushBgView.addSubview(line)
        
        saveButton = UIButton(type: .custom)
        saveButton.setTitle("保存到本地", for: .normal)
        saveButton.setTitleColor(ColorEA5504, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonClicked(sender:)), for: .touchUpInside)
        
        self.pushBgView.addSubview(saveButton)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(imageView.snp.width)
        }
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-50)
        }
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
//        //长按识别二维码
//        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(QRLongPress(gesture:)))
//        longPress.minimumPressDuration = 1
//        imageView.addGestureRecognizer(longPress)
//        imageView.isUserInteractionEnabled = true
    }
    
    //MARK: - 长按二维码识别
//    @objc func QRLongPress(gesture: UILongPressGestureRecognizer) {
//
//        if (gesture.state == UIGestureRecognizerState.began) {
//
//            //1.初始化扫描仪，设置设别类型和识别质量
//            let options = ["IDetectorAccuracy" : CIDetectorAccuracyHigh]
//            let detector: CIDetector = CIDetector.init(ofType: "CIDetectorTypeQRCode", context: nil, options: options)!
//            //2.扫描获取的特征组
//            let features = detector.features(in: CIImage.init(cgImage: (self.imageView.image?.cgImage)!))
//            //3.获取扫描结果
//            let feature = features[0] as! CIQRCodeFeature
//            let scannedResult = feature.messageString
//            //4.获取之后的操作
//            print(scannedResult!)
//
//            UIApplication.shared.openURL(URL(string: scannedResult!)!)
//
//        } else if (gesture.state == UIGestureRecognizerState.ended) {
//
//        }
//    }
    
    @objc private func saveButtonClicked(sender: UIButton) {
        
        guard let image = imageView.image else { return }

        saveToPhotosAlbum(with: image)
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
