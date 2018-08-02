//
//  DaletouStandardBlueCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
protocol DaletouStandardBlueCellDelegate {
    func didSelect(cell: DaletouStandardBlueCell, model : DaletouDataModel) -> Void
}

class DaletouStandardBlueCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 2 + 15 * 2 + 11
    static var omCellHeight : CGFloat = (DaletouItem.width * 2) + (21 * 2) + 11
    
    public var delegate : DaletouStandardBlueCellDelegate!
    
    @IBOutlet weak var blueView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        blueView.configure(with: DaletouDataModel.getData(ballStyle: .blue))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DaletouStandardBlueCell {
    public func configure(with display : DLTDisplayStyle) {
        blueView.configure(with: display)
    }
}
