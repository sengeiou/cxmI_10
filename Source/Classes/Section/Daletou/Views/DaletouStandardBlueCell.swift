//
//  DaletouStandardBlueCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouStandardBlueCell: UITableViewCell {

    @IBOutlet weak var blueView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        blueView.configure(with: DaletouDataModel.getData(isRed: false))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
