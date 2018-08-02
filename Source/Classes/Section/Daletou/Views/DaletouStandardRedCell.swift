//
//  DaletouStandardRedCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouStandardRedCellDelegate {
    func didSelect(cell: DaletouStandardRedCell, model : DaletouDataModel) -> Void
}

class DaletouStandardRedCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 5 + 15 * 5 + 54
    static var omCellHeight : CGFloat = (DaletouItem.width * 5) + (21 * 5) + 65
    
    public var delegate : DaletouStandardRedCellDelegate!
    
    @IBOutlet weak var redView: DaletouCollectionView!
    
    public var displayType : DLTDisplayStyle!
    
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

        
    }
}

extension DaletouStandardRedCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model)
    }
}

extension DaletouStandardRedCell {
    public func configure(model : DaletouOmissionModel, display : DLTDisplayStyle) {
        
    }
    
    public func configure(with display : DLTDisplayStyle) {
        redView.configure(with: display)
    }
}
