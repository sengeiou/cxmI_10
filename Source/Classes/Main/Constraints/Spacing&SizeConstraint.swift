//
//  Spacing&SizeConstraint.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UIKit

let defaultScale = screenWidth / 375

/// 距离屏幕左侧间隔
let leftSpacing = 15 * defaultScale
/// 距离屏幕右侧间隔
let rightSpacing: CGFloat = 17.5 * defaultScale
/// 水平方向间隔
let horizontalSpacing = 10
/// 竖直方向间隔
let verticalSpacing = 12.5
/// 输入框高度
let textFieldHeight = 40
/// label高度
let labelHeight = 20
/// 按钮高度
let buttonHeight : CGFloat = 44 * defaultScale
/// 登录等 按钮的高度
let loginButHeight : CGFloat = 44 * defaultScale
/// 登录按钮距离上方的高度
let loginButTopSpacing : CGFloat = 30 * defaultScale
///
let loginTextFieldHeight = 55
/// banner高度
let bannerHeight : CGFloat = 153.0 * defaultScale
/// 分隔线 高度
let SeparationLineHeight = 1


//MARK: - TABLE VIEW
/// 默认cell 高度
let defaultCellHeight : CGFloat = 60 * defaultScale
/// heightForHeaderInSection
let sectionHeaderHeight : CGFloat = 5
let SeparatorLeftSpacing : CGFloat = 10
//MARK: - 提现界面高度
let WithdrawalViewHeight : CGFloat = 166 * defaultScale
let BankCardHeight : CGFloat = 120 * defaultScale
let BankCardWidth : CGFloat = 340 * defaultScale
let BankCardIconWidth : CGFloat = 26 + 6
let BankCardDeleteWidth: CGFloat = 14 * defaultScale

//MARK: - 优惠券
let CouponCellHeight : CGFloat = 131 * defaultScale

//MARK: - 购彩记录
let RecordCellHeight : CGFloat = 71 * defaultScale
let OrderDetailCellHeight: CGFloat = 65 * defaultScale
//let OrderHeaderViewHeight: CGFloat = defaultScale < 1 ? 123 : 122.5 * defaultScale 1.1.4 更新
let OrderHeaderViewHeight: CGFloat = defaultScale < 1 ? 123 : 122.5 * defaultScale
let orderSectionHeaderHeight: CGFloat = 36 * defaultScale
//MARK: -  首页足球尺寸


