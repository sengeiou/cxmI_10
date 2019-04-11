//
//  LoLPlayCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol LoLPlayCellProtocol {
    func didTipItem(view : LoLPlayCell, type : ItemType, section : Int) -> Void
}

class LoLPlayCell: UITableViewCell {

    public var delegate : LoLPlayCellProtocol!
    
    @IBOutlet weak var title : UILabel!
    
    @IBOutlet weak var homeOdds : UIButton!
    @IBOutlet weak var visiOdds : UIButton!
    
    @IBAction func home(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipItem(view: self, type: .homeTeam, section: self.tag)
    }
    @IBAction func visi(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipItem(view: self, type: .visiTeam, section: self.tag)
    }
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeOdds.titleLabel?.numberOfLines = 2
        visiOdds.titleLabel?.numberOfLines = 2
        homeOdds.titleLabel?.textAlignment = .center
        visiOdds.titleLabel?.textAlignment = .center
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
