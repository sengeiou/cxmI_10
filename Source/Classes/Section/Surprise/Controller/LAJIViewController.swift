//
//  LAJIViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/21.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LAJIViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
        }
        
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    lazy var button : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("打开相册", for: .normal)
        button.setTitleColor(ColorEA5504, for: .normal)
        button.addTarget(self, action: #selector(openAlbum), for: .touchUpInside)
        
        
        
        return button
    }()
    
    var imagePicker : UIImagePickerController!
    
    
    @objc private func openAlbum() {
        
        self.present(imagePicker, animated: true, completion: nil )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension LAJIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        picker.dismiss(animated: true) {
            let storyMakervc = StoryMakeImageEditorViewController(image: image)
            self.present(storyMakervc!, animated: true, completion: nil)
        }
    }
}
