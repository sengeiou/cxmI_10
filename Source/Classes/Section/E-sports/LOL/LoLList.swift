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

class LoLList: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var matchCount : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var selectDetail : UILabel!
    @IBOutlet weak var confirmButton : UIButton!
    
    private var viewModel : LoLModel = LoLModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "英雄联盟"
        initSubview()
        loadNewData()
        
        var mo1 = LoLData()
        mo1.id = "1"
        mo1.homeTeam = "LGD"
        mo1.visiTeam = "RNG"
        mo1.betDetail.onNext("xxxx")
        
        var play1 = LoLPlayData()
        play1.title = "获胜方"
        play1.odds = ["3.0","1.2"]
        
        var play2 = LoLPlayData()
        play2.title = "对局比分"
        play2.odds = ["2.5","3.5"]
        
        var play4 = LoLPlayData()
        play4.title = "对局总数"
        play4.odds = ["2.5","3.5","5"]
        
        var play3 = LoLPlayData()
        play3.title = "地图获胜"
        play3.odds = ["2.5","3.5","1.0","2.3"]
        
        var play5 = LoLPlayData()
        play5.title = "获得一血"
        play5.odds = ["2.5","3.5","2.5","3.5","1.0","2.3"]
        
        mo1.play.append(play1)
        mo1.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        mo1.play.append(play1)
        mo1.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        
        var mo2 = LoLData()
        mo2.id = "2"
        mo2.homeTeam = "OMG"
        mo2.visiTeam = "IG"
        mo2.betDetail.onNext("想你啊")
        var mo3 = LoLData()
        mo3.id = "1"
        mo3.homeTeam = "LGD"
        mo3.visiTeam = "RNG"
        mo3.betDetail.onNext("抱抱啊")
    
        
        mo2.play.append(play1)
        mo2.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        mo2.play.append(play1)
        mo2.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        
        mo3.play.append(play1)
        mo3.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        mo3.play.append(play1)
        mo3.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        
        
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
        viewModel.confirmColor.drive(confirmButton.rx.backgroundColor()).disposed(by: bag)
        viewModel.confirmStyle.drive(confirmButton.rx.isUserInteractionEnabled).disposed(by: bag)
        
    }
    
}

// MARK: - 点击事件
extension LoLList {
    // 删除
    @IBAction func delete(sender : UIButton) {
        viewModel.deleteAllSelect()
    }
    // 确认
    @IBAction func confirm(sender : UIButton) {
        print("确认")
        viewModel.confirm(vc: self)
    }
}

extension LoLList : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(storyboard: .ESports)
        let vc = story.instantiateViewController(withIdentifier: "LoLPlayList") as! LoLPlayList
        
        let data = viewModel.data[indexPath.row]
        vc.defData = data
        pushViewController(vc: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

// MARK: - DataSource
extension LoLList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLCell", for: indexPath) as! LoLCell
        
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
extension LoLList {
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
extension LoLList {
    private func loadNewData() {
        
    }
    
}
