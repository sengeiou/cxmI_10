//
//  ScreenConstraint.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//  屏幕相关常量

import Foundation
import UIKit


let screenHeight = UIScreen.main.bounds.height
let screenWidth  = UIScreen.main.bounds.width


let SafeAreaTopHeight    = screenHeight == 812.0 ? 88 : 64
let SafeAreaBottomHeight: CGFloat = screenHeight == 812.0 ? 24 : 0


