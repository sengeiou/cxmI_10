//
//  LeagueDetailCourseTabItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueDetailCourseTabItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 20) / 4 - 5
    static let height : CGFloat = 30
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    
    private func initSubview() {
        title.backgroundColor = ColorFFFFFF
    }
    
}

extension LeagueDetailCourseTabItem {
    public func configure(with data : CourseTabDataModel) {
        title.text = data.title
        
        _ = data.select.asObserver()
            .subscribe(onNext: { [weak self](select) in
                self?.changeSelectItem(select: select)
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
    private func changeSelectItem(select : Bool) {
        statusIcon.isHidden = !select
    }
}
