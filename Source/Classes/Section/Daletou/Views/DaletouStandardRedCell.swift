//
//  DaletouStandardRedCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouStandardRedCell: UITableViewCell {

    static let height : CGFloat = 240 + 15
    
    @IBOutlet weak var redView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        redView.configure(with: DaletouDataModel.getData(ballStyle: .red))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DaletouStandardRedCell {
    public func configure(model : DaletouOmissionModel) {
        
    }
}
