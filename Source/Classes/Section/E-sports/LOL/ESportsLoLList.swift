//
//  ESportsLoLList.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ESportsLoLList: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var matchCount : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var selectDetail : UILabel!
    @IBOutlet weak var confirmButton : UIButton!
    
    private var viewModel : ESportsLoLModel = ESportsLoLModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "英雄联盟"
        initSubview()
        loadNewData()
        
        var mo1 = ESportsLoLData()
        mo1.id = "1"
        mo1.homeTeam = "LGD"
        mo1.visiTeam = "RNG"
        mo1.betDetail.onNext("xxxx")
        
        var mo2 = ESportsLoLData()
        mo2.id = "2"
        mo2.homeTeam = "OMG"
        mo2.visiTeam = "IG"
        mo2.betDetail.onNext("想你啊")
        var mo3 = ESportsLoLData()
        mo3.id = "1"
        mo3.homeTeam = "LGD"
        mo3.visiTeam = "RNG"
        mo3.betDetail.onNext("抱抱啊")
        
        let sss : Set<ESportsLoLData> = Set(arrayLiteral: mo1,mo2,mo3)
        
        viewModel.data.append(mo1)
        viewModel.data.append(mo2)
        viewModel.data.append(mo3)
        viewModel.data.append(mo1)
        viewModel.data.append(mo2)
        viewModel.data.append(mo3)
        
        setData()
    }
    
    private func setData() {
        viewModel.matchCount.drive(matchCount.rx.text).disposed(by: bag)
        viewModel.seDetail.drive(selectDetail.rx.text).disposed(by: bag)
        viewModel.confirmStyle.drive(confirmButton.rx.backgroundColor()).disposed(by: bag)
        
        
    }
    
}

// MARK: - 点击事件
extension ESportsLoLList {
    // 删除
    @IBAction func delete(sender : UIButton) {
        
    }
    // 确认
    @IBAction func confirm(sender : UIButton) {
        
    }
}

extension ESportsLoLList : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

// MARK: - DataSource
extension ESportsLoLList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ESportsLoLCell", for: indexPath) as! ESportsLoLCell
        
        let data = viewModel.data[indexPath.row]
        
        cell.season.text = data.season
        cell.date.text = data.date
        cell.homeTeam.text = data.homeTeam
        cell.visiTeam.text = data.visiTeam
        if let url = URL(string: data.homeIcon) {
            cell.homeIcon.kf.setImage(with: url)
        }
        if let url = URL(string: data.visiIcon) {
            cell.visiIcon.kf.setImage(with: url)
        }
        
        data.betDetail.bind(to: cell.betDetail.rx.text).disposed(by: bag)
        
        return cell
    }
}

// MARK: - 初始化
extension ESportsLoLList {
    private func initSubview() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = ColorE9E9E9
        
        setNavRightItem()
    }
    private func setNavRightItem() {
        let right = UIButton(type: .custom)
        right.setTitle("帮助", for: .normal)
        right.setTitleColor(ColorFFFFFF, for: .normal)
        right.addTarget(self, action: #selector(help(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right)
    }
    
    @objc private func help(sender : UIButton) {
        viewModel.data[0].betDetail.onNext("xxx123123")
    }
    
}

// MARK: - 网络请求
extension ESportsLoLList {
    private func loadNewData() {
        
    }
    
}
