//
//  UILabelEx.swift
//  彩小蜜
//
//  Created by 笑 on 2019/3/4.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: UILabel {
   
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { label, color in
            label.backgroundColor = color
        }
    }

}
