//
//  UIButtonEx.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    func backgroundColor(for controlState: UIControl.State = []) -> Binder<UIColor?> {
        return Binder(self.base) { (button, color) -> () in
            button.backgroundColor = color
        }
    }
}
