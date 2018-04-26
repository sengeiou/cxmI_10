//
//  NoticeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    private var title : UILabel!
    private var timelb: UILabel!
    private var detaillb: UILabel!
    private var detailBut: UIButton!
    private var activity: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        title = getLabel()
    }
    
    private func getLabel() -> UILabel{
        let lab = UILabel()
        
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
