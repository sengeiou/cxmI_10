//
//  DaletouDanRedCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


protocol DaletouDanRedCellDelegate {
    func didSelect(cell: DaletouDanRedCell, model : DaletouDataModel) -> Void
}

class DaletouDanRedCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 5 + 15 * 6 + 52
    static var omCellHeight : CGFloat = (DaletouItem.width * 5) + (21 * 6) + 15 + 52
    
    public var delegate : DaletouDanRedCellDelegate!
    
    @IBOutlet weak var redView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        redView.delegate = self
        redView.configure(with: DaletouDataModel.getData(ballStyle: .red))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DaletouDanRedCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model)
    }
}
extension DaletouDanRedCell {
    public func configure(with display : DLTDisplayStyle) {
        redView.configure(with: display)
    }
}
