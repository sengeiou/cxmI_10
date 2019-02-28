//
//  LoLPlayCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class LoLPlayCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    
    @IBOutlet weak var homeOdds : UILabel!
    @IBOutlet weak var homeTeam : UILabel!
    @IBOutlet weak var visiOdds : UILabel!
    @IBOutlet weak var visiTeam : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
