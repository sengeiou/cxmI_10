//
//  DaletouDragBlueCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouDragBlueCellDelegate {
    func didSelect(cell: DaletouDragBlueCell, model : DaletouDataModel) -> Void
}

class DaletouDragBlueCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 2 + 15 * 2 + 50
    static var omCellHeight : CGFloat = (DaletouItem.width * 2) + (21 * 3) + 50
    
    public var delegate : DaletouDragBlueCellDelegate!
    
    @IBOutlet weak var blueView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        blueView.delegate = self
        blueView.configure(with: DaletouDataModel.getData(ballStyle: .blue))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DaletouDragBlueCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model)
    }
}
extension DaletouDragBlueCell{
    public func configure(with display : DLTDisplayStyle) {
        blueView.configure(with: display)
    }
}
