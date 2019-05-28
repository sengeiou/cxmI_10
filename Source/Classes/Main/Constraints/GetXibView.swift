//
//  getXibView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/5/24.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation

public func getXibView(xibName: String) -> UIView {
    
    return (Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)?.first as? UIView)!
    
}
