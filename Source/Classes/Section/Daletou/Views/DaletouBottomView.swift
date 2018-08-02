//
//  DaletouBottomView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouBottomViewDelegate {
    func didTipDelete() -> Void
    func didTipConfirm() -> Void
}

class DaletouBottomView: UIView {

    public var delegate: DaletouBottomViewDelegate!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deleteBut : UIButton!
    
    @IBOutlet weak var confirmBut : UIButton!
    
    @IBAction func confirmClick(_ sender: UIButton) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didTipConfirm()
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didTipDelete()
    }
    

}
