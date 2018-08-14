//
//  CXMMDLTTrendSettingVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/14.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDLTTrendSettingVC: BasePopViewController {

    private var periods30 : UIButton!    // 30期
    private var periods50 : UIButton!    // 50期
    private var periods100: UIButton!    // 100期
    
    private var omissionShow: UIButton!  // 显示遗漏
    private var omissionHide: UIButton!  // 隐藏遗漏
    
    private var statisticsShow : UIButton! // 显示统计
    private var statisticsHide : UIButton! // 隐藏统计
    
    private var sortShow : UIButton!  // 正序
    private var sortHide : UIButton!  // 倒序
    
    private var bottomView: FootballFilterBottomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        
        initSubview()
    }

    private func initSubview() {
        self.viewHeight = 310
        
        let titleLabel = getLabel()
        titleLabel.font = Font16
        titleLabel.text = "彩小秘 · 走势图设置"
        titleLabel.textAlignment = .center
        
        let line = UIImageView()
        line.image = UIImage(named:"line")
        
        let qishu = getLabel()
        qishu.text = "期数"
        qishu.textColor = Color787878
        
        let yilou = getLabel()
        yilou.text = "遗漏"
        yilou.textColor = Color787878
        
        let tongji = getLabel()
        tongji.text = "统计"
        tongji.textColor = Color787878
        
        let paixu = getLabel()
        paixu.text = "排序"
        paixu.textColor = Color787878
        
        let shuoming = getLabel()
        shuoming.textColor = Color9F9F9F
        shuoming.textAlignment = .center
        shuoming.text = "走势图底部的出现次数等于统计数"
        
        bottomView = FootballFilterBottomView()
        bottomView.delegate = self
        
        
        self.periods30 = getButton()
        self.periods50 = getButton()
        self.periods100 = getButton()
        
        let title30 = getLabel()
        let title50 = getLabel()
        let title100 = getLabel()
        
        title30.text = "30期"
        title50.text = "50期"
        title100.text = "100期"
        
        
        self.omissionShow = getButton()
        self.omissionHide = getButton()
        
        let omissionShowTitle = getLabel()
        let omissionHideTitle = getLabel()
        
        omissionShowTitle.text = "显示遗漏"
        omissionHideTitle.text = "隐藏遗漏"
        
        self.statisticsShow = getButton()
        self.statisticsHide = getButton()
        
        let statisShowTitle = getLabel()
        let statisHideTitle = getLabel()
        
        statisShowTitle.text = "显示统计"
        statisHideTitle.text = "隐藏统计"
        
        self.sortShow = getButton()
        self.sortHide = getButton()
        
        let sortShowTitle = getLabel()
        let sortHideTitle = getLabel()
        
        sortShowTitle.text = "正序排列"
        sortHideTitle.text = "倒序排列"
        
        
        self.pushBgView.addSubview(titleLabel)
        self.pushBgView.addSubview(line)
        self.pushBgView.addSubview(qishu)
        self.pushBgView.addSubview(yilou)
        self.pushBgView.addSubview(tongji)
        self.pushBgView.addSubview(paixu)
        self.pushBgView.addSubview(shuoming)
        self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(periods30)
        self.pushBgView.addSubview(periods50)
        self.pushBgView.addSubview(periods100)
        self.pushBgView.addSubview(title30)
        self.pushBgView.addSubview(title50)
        self.pushBgView.addSubview(title100)
        self.pushBgView.addSubview(omissionShow)
        self.pushBgView.addSubview(omissionHide)
        self.pushBgView.addSubview(omissionShowTitle)
        self.pushBgView.addSubview(omissionHideTitle)
        self.pushBgView.addSubview(statisticsShow)
        self.pushBgView.addSubview(statisticsHide)
        self.pushBgView.addSubview(statisShowTitle)
        self.pushBgView.addSubview(statisHideTitle)
        self.pushBgView.addSubview(sortShow)
        self.pushBgView.addSubview(sortHide)
        self.pushBgView.addSubview(sortShowTitle)
        self.pushBgView.addSubview(sortHideTitle)
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        qishu.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(25)
            make.left.equalTo(35)
            make.height.equalTo(14)
            make.width.equalTo(50)
        }
        yilou.snp.makeConstraints { (make) in
            make.top.equalTo(qishu.snp.bottom).offset(25)
            make.left.right.height.equalTo(qishu)
        }
        tongji.snp.makeConstraints { (make) in
            make.top.equalTo(yilou.snp.bottom).offset(25)
            make.left.right.height.equalTo(qishu)
        }
        paixu.snp.makeConstraints { (make) in
            make.top.equalTo(tongji.snp.bottom).offset(25)
            make.left.right.height.equalTo(qishu)
        }
        
        shuoming.snp.makeConstraints { (make) in
            make.top.equalTo(paixu.snp.bottom).offset(18)
            make.left.right.equalTo(0)
            make.height.equalTo(paixu)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        
        periods30.snp.makeConstraints { (make) in
            make.top.equalTo(qishu)
            make.left.equalTo(qishu.snp.right).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(15)
        }
        title30.snp.makeConstraints { (make) in
            make.top.equalTo(qishu)
            make.left.equalTo(periods30.snp.right)
            make.width.equalTo(title50)
            make.height.equalTo(qishu)
        }
        periods50.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(periods30)
            make.left.equalTo(title30.snp.right)
        }
        title50.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(title30)
            make.left.equalTo(periods50.snp.right)
        }
        periods100.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(periods30)
            make.left.equalTo(title50.snp.right)
        }
        title100.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(title30)
            make.left.equalTo(periods100.snp.right)
            make.right.equalTo(-35)
        }
        
        omissionShow.snp.makeConstraints { (make) in
            make.centerY.equalTo(yilou.snp.centerY)
            make.left.width.height.equalTo(periods30)
        }
        omissionShowTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(omissionShow.snp.centerY)
            make.left.equalTo(omissionShow.snp.right)
            make.height.equalTo(periods30)
            make.width.equalTo(omissionHideTitle)
        }
        omissionHide.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(omissionShow)
            make.left.equalTo(omissionShowTitle.snp.right)
        }
        omissionHideTitle.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(omissionShowTitle)
            make.left.equalTo(omissionHide.snp.right)
            make.right.equalTo(-50)
        }
        
        statisticsShow.snp.makeConstraints { (make) in
            make.centerY.equalTo(tongji.snp.centerY)
            make.left.width.height.equalTo(periods30)
        }
        statisShowTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(statisticsShow.snp.centerY)
            make.left.equalTo(omissionShowTitle)
            make.height.equalTo(omissionShowTitle)
            make.width.equalTo(omissionShowTitle)
        }
        statisticsHide.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(omissionHide)
            make.top.equalTo(statisticsShow)
        }
        statisHideTitle.snp.makeConstraints { (make) in
            make.top.equalTo(statisShowTitle)
            make.left.width.height.equalTo(omissionHideTitle)
        }
        
        sortShow.snp.makeConstraints { (make) in
            make.centerY.equalTo(paixu.snp.centerY)
            make.left.width.height.equalTo(periods30)
        }
        sortShowTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(sortShow.snp.centerY)
            make.left.equalTo(omissionShowTitle)
            make.height.equalTo(omissionShowTitle)
            make.width.equalTo(omissionShowTitle)
        }
        sortHide.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(omissionHide)
            make.top.equalTo(sortShow)
        }
        sortHideTitle.snp.makeConstraints { (make) in
            make.top.equalTo(sortShowTitle)
            make.left.width.height.equalTo(omissionHideTitle)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.textColor = Color505050
        lab.font = Font14
        return lab
    }
    private func getButton() -> UIButton {
        let but = UIButton(type: .custom)
        but.setImage(UIImage(named: "SelectionBox2"), for: .normal)
        but.setImage(UIImage(named: "Selected2"), for: .selected)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
        but.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)
        return but
    }

    private func getLine() -> UIView {
        let view = UIView()
        view.backgroundColor = ColorE9E9E9
        return view
    }
}

extension CXMMDLTTrendSettingVC : FootballFilterBottomViewDelegate {
    func filterConfirm() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func filterCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension CXMMDLTTrendSettingVC {
    @objc private func didButtonClick(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
