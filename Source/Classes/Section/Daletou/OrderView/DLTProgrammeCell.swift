//
//  DLTProgrammeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTProgrammeCell: UITableViewCell {

    @IBOutlet weak var programmeNo : UILabel! //方案编号
    @IBOutlet weak var creatTime : UILabel!  // 创建时间
    @IBOutlet weak var orderTime : UILabel!  // 接单时间
    @IBOutlet weak var ticketTime : UILabel! // 出票时间
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DLTProgrammeCell {
    public func configure(with data : DLTOrderDetailModel) {
        programmeNo.text = data.programmeSn
        creatTime.text = data.createTime
        orderTime.text = data.acceptTime
        ticketTime.text = data.ticketTime
    }
}
