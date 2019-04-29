//
//  LoLPlayConfirm.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//  英雄联盟投注确认页

import UIKit
import RxSwift
import RxCocoa

class LoLPlayConfirm: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var betNum : UIButton!      // 倍数
    @IBOutlet weak var betDetail : UILabel!   // 投注信息
    @IBOutlet weak var confirm : UIButton!    // 确认
    
    @IBAction func confirm(sender : UIButton) {
        
    }
    @IBAction func betNumSe(sender : UIButton) {
        
    }
    
    private var viewModel : LoLConfirmModel = LoLConfirmModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "投注确认"
        initSubview()
        setData()
    }
}

// MARK: - 设置数据
extension LoLPlayConfirm {
    private func setData() {
        viewModel.betCount.drive(titleLabel.rx.text).disposed(by: bag)
        viewModel.betDetail.drive(betDetail.rx.text).disposed(by: bag)
        viewModel.confirmColor.bind(to: confirm.rx.backgroundColor()).disposed(by: bag)
        viewModel.confirmStyle.bind(to: confirm.rx.isUserInteractionEnabled).disposed(by: bag)
        
    }
}

// MARK: - 初始化
extension LoLPlayConfirm {
    private func initSubview() {
        
    }
}

extension LoLPlayConfirm : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0 + 85.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
extension LoLPlayConfirm : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLPlayConfirmCell", for: indexPath) as! LoLPlayConfirmCell
        
        return cell
    }
}


