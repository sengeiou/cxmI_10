//
//  DaletouStandardRedCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouStandardRedCellDelegate {
    func didSelect(cell: DaletouStandardRedCell, model : DaletouDataModel, indexPath : IndexPath) -> Void
}

class DaletouStandardRedCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 5 + 15 * 5 + 54
    static var omCellHeight : CGFloat = (DaletouItem.width * 5) + (21 * 5) + 65
    
    public var delegate : DaletouStandardRedCellDelegate!
    
    @IBOutlet weak var redView: DaletouCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    
    public var displayType : DLTDisplayStyle!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        redView.delegate = self
        self.detailLabel.text = ""
        //redView.configure(with: DaletouDataModel.getData(ballStyle: .red))
    }
    
}

extension DaletouStandardRedCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel, indexPath : IndexPath) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model, indexPath: indexPath)
    }
}

extension DaletouStandardRedCell {
    public func configure(model : DaletouOmissionModel, display : DLTDisplayStyle) {
        let att = NSMutableAttributedString(string: "奖池: ",
            attributes: [NSAttributedString.Key.foregroundColor: Color787878])
        let money = NSAttributedString(string: "\(model.prizes)",
            attributes: [NSAttributedString.Key.foregroundColor: ColorE85504])
        att.append(money)
        self.detailLabel.attributedText = att
    }
    public func configure(with list : [DaletouDataModel]) {
        redView.configure(with: list)
    }
    public func configure(with display : DLTDisplayStyle) {
        redView.configure(with: display)
    }
}
