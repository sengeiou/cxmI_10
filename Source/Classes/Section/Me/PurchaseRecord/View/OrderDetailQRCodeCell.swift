//
//  OrderDetailQRCodeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/12.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

protocol OrderDetailQRCodeCellDelegate {
    func didTipCopy(cell : OrderDetailQRCodeCell, model : AppendInfo) -> Void
    func didTipCall(cell : OrderDetailQRCodeCell, model : AppendInfo) -> Void
}

class OrderDetailQRCodeCell: UITableViewCell {

    public var delegate : OrderDetailQRCodeCellDelegate!
    
    private var model : AppendInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    
    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var wechat : UILabel!
    @IBOutlet weak var phone : UILabel!
    
    @IBOutlet weak var copyButton : UIButton!
    @IBOutlet weak var callButton : UIButton!
    
    @IBAction func copyClicked(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipCopy(cell: self, model: model)
    }
    
    @IBAction func callClicked(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipCall(cell: self, model: model)
    }
    
}

extension OrderDetailQRCodeCell {
    public func configure(with data : AppendInfo) {
        self.model = data
        if let url = URL(string: data.imgurl){
            icon.kf.setImage(with: url)
        }
        wechat.text = data.wechat
        phone.text = data.phone
    }
}

extension OrderDetailQRCodeCell {
    private func initSubview() {
        copyButton.layer.cornerRadius = 2
        copyButton.layer.borderColor = ColorE85504.cgColor
        copyButton.layer.borderWidth = 1
        
        wechat.text = ""
        phone.text = ""
        icon.image = nil
    }
}
