//
//  DaletouDanRedCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


protocol DaletouDanRedCellDelegate {
    func didSelect(cell: DaletouDanRedCell, model : DaletouDataModel, indexPath : IndexPath) -> Void
    func didTipHelp() -> Void
}

class DaletouDanRedCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 5 + 15 * 6 + 52
    static var omCellHeight : CGFloat = (DaletouItem.width * 5) + (21 * 6) + 15 + 52
    
    public var delegate : DaletouDanRedCellDelegate!
    
    @IBOutlet weak var redView: DaletouCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    public func reloadData() {
        DispatchQueue.main.async {
            self.redView.collectionView.reloadData()
            self.setNeedsLayout()
        }
    }
    
    @IBAction func helpClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipHelp()
    }
    private func setSubview() {
        redView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DaletouDanRedCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel, indexPath : IndexPath) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model, indexPath: indexPath)
    }
}
extension DaletouDanRedCell {
    public func configure(model : DaletouOmissionModel, display : DLTDisplayStyle) {
        let att = NSMutableAttributedString(string: "奖池: ",
                                            attributes: [NSAttributedStringKey.foregroundColor: Color787878])
        let money = NSAttributedString(string: "\(model.prizes)",
            attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
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
