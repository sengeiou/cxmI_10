//
//  CXMMPrizeMatchHistoryFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol CXMMPrizeMatchHistoryFilterVCDelegate {
    func didSelected(date : String) -> Void
}

class CXMMPrizeMatchHistoryFilterVC: BasePopViewController {

    public var delegate : CXMMPrizeMatchHistoryFilterVCDelegate!
    
    public var selectedDate : String! {
        didSet{
            if selectedDate != nil, selectedDate != "" {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "YYYY-MM-dd"
                let date = dateFormater.date(from: self.selectedDate)
                datePaker.setDate(date!, animated: true)
            }
        }
    }
    
    private var toolsView : UIView!
    private var cancelButton : UIButton!
    private var confimButton : UIButton!
    
    private var datePaker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
        
        
    }

    private func initSubview() {
        self.viewHeight = 250
        
        toolsView = UIView()
        toolsView.backgroundColor = ColorEA5504
        
        cancelButton = getButton(title: "取消")
        cancelButton.tag = 100
        confimButton = getButton(title: "确定")
        confimButton.tag = 200
        
        datePaker = UIDatePicker(frame: CGRect.zero)
        datePaker.datePickerMode = .date
        datePaker.locale = Locale(identifier: "zh_CN")
        datePaker.addTarget(self, action: #selector(chooseDate(_:)), for: .valueChanged)
        
        self.pushBgView.addSubview(toolsView)
        self.pushBgView.addSubview(datePaker)
        toolsView.addSubview(cancelButton)
        toolsView.addSubview(confimButton)
        
        toolsView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(40)
        }
        datePaker.snp.makeConstraints { (make) in
            make.top.equalTo(toolsView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(0)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(80)
        }
        confimButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(80)
        }
    }

    private func getButton(title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        but.setTitleColor(ColorFFFFFF, for: .normal)
        but.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        
        return but
    }
    @objc private func chooseDate(_ datePicker:UIDatePicker) {
        let chooseDate = datePicker.date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        print(dateFormater.string(from: chooseDate))
        
    
        
        self.selectedDate = dateFormater.string(from: chooseDate)
    }
 
    @objc private func buttonClick(_ sender : UIButton) {
        switch sender.tag {
        case 100:
            break
        case 200:
            guard delegate != nil else { return }
            delegate.didSelected(date: self.selectedDate)
        default:
            break
        }
        self.dismiss(animated: true , completion: nil)
    }
}
