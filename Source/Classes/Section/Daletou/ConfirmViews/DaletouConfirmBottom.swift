//
//  DaletouConfirmBottom.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouConfirmBottomDelegate {
    func didTipAppend(isAppend : Bool) -> Void
    func didTipMultiple() -> Void
    func didTipConfirm() -> Void
}

class DaletouConfirmBottom: UIView {
    
    var delegate : DaletouConfirmBottomDelegate!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var multipleBut : UIButton!
    @IBOutlet weak var confirmBut : UIButton!
    @IBAction func MultipleClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipMultiple()
    }
    @IBAction func confirmClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipConfirm()
    }
    
    @IBAction func appendClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard delegate != nil else { return }
        delegate.didTipAppend(isAppend: sender.isSelected)
    }
}
