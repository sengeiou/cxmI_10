//
//  UIImageViewEx.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/26.
//  Copyright © 2018 韩笑. All rights reserved.
//  ImageView 扩展.
//  1、loadGif //加载Gif图

import Foundation

extension UIImageView {
    func loadGifWith(urlStr : String){
        guard let url = URL(string: urlStr) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        
        let imageCount = CGImageSourceGetCount(imageSource)
        
        var images = [UIImage]()
        var totalDuration  : TimeInterval = 0
        
        for index in 0..<imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as? Dictionary<CFString, Any> else { continue }
            
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? Dictionary<CFString, Any> else { continue}
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? Double else { continue }
            
            totalDuration += frameDuration
        }
        
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
}
