//
//  DLTPrizeTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTPrizeTitleCell: UITableViewCell {

    @IBOutlet weak var numOne: UILabel!
    @IBOutlet weak var numTwo: UILabel!
    @IBOutlet weak var numThree: UILabel!
    @IBOutlet weak var numFour: UILabel!
    @IBOutlet weak var numFive: UILabel!
    @IBOutlet weak var numSix: UILabel!
    @IBOutlet weak var numSeven: UILabel!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        self.numOne.layer.cornerRadius = 14
        self.numTwo.layer.cornerRadius = 14
        self.numThree.layer.cornerRadius = 14
        self.numFour.layer.cornerRadius = 14
        self.numFive.layer.cornerRadius = 14
        self.numSix.layer.cornerRadius = 14
        self.numSeven.layer.cornerRadius = 14
        
        self.numOne.layer.masksToBounds = true
        self.numTwo.layer.masksToBounds = true
        self.numThree.layer.masksToBounds = true
        self.numFour.layer.masksToBounds = true
        self.numFive.layer.masksToBounds = true
        self.numSix.layer.masksToBounds = true
        self.numSeven.layer.masksToBounds = true
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
