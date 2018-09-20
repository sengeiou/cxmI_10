//
//  BasketballHunheViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BBHunheSectionModel {
    var shengfu : BBHunheModel = BBHunheModel()
    var ragnfen  : BBHunheModel = BBHunheModel()
    var daxiaofen : BBHunheModel = BBHunheModel()
    var shengfencha  : [BBHunheModel] = [BBHunheModel]()
}
class BBHunheModel {
    var isSelected : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var bgColor : BehaviorSubject<UIColor> = BehaviorSubject(value: ColorFFFFFF)
}

struct BasketballHunheViewModel {
    var list : [BBHunheModel] = [BBHunheModel]()
}

extension BasketballHunheViewModel {
    
}


