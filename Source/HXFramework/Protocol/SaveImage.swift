//
//  SaveImage.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/1.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol SaveImageProtocol {
    
}
extension SaveImageProtocol {
    public func saveToPhotosAlbum(with image: UIImage) {
        
        SaveImage().saveToPhotosAlbum(with: image)
    }
}

class SaveImage  {
    public func saveToPhotosAlbum(with image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }else{
            showMessage = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showMessage)
    }
}
