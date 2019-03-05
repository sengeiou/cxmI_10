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
        
        var item = LoLPlayItemData()
        item.title = "地图1"
        item.odds = "2.1"
        
        var mo1 = LoLData()
        mo1.id = "1"
        mo1.homeTeam = "LGD"
        mo1.visiTeam = "RNG"
        mo1.betDetail.onNext("xxxx")
        
        var play1 = LoLPlayData()
        play1.title = "获胜方"
        play1.playType = "0"
        var item1 = LoLPlayItemData()
        item1.title = "LGD"
        item1.odds = "2.1"
        var item2 = LoLPlayItemData()
        item2.title = "RNG"
        item2.odds = "3.23"
        
        play1.homePlay.append(item1)
        play1.visiPlay.append(item2)
        
        var play2 = LoLPlayData()
        play2.title = "对\n局\n比\n分"
        play2.playType = "1"
        var item3 = LoLPlayItemData()
        item3.title = "4-0"
        item3.odds = "8.1"
        
        play2.homePlay.append(item3)
        play2.homePlay.append(item3)
        play2.homePlay.append(item3)
        play2.homePlay.append(item3)
        play2.visiPlay.append(item3)
        play2.visiPlay.append(item3)
        play2.visiPlay.append(item3)
        play2.visiPlay.append(item3)
        
        var play4 = LoLPlayData()
        play4.title = "对\n局\n总\n数"
        play4.playType = "2"
        var item4 = LoLPlayItemData()
        item4.title = "高于3.2"
        item4.odds = "8.1"
        var item5 = LoLPlayItemData()
        item5.title = "低于3.2"
        item5.odds = "3.1"
        
        play4.homePlay.append(item4)
        play4.homePlay.append(item4)
        play4.homePlay.append(item4)
        play4.visiPlay.append(item5)
        play4.visiPlay.append(item5)
        play4.visiPlay.append(item5)
        
        var play3 = LoLPlayData()
        play3.title = "地\n图\n获\n胜"
        play3.playType = "3"
        var item6 = LoLPlayItemData()
        item6.title = "地图1"
        item6.odds = "6.1"
        play3.homePlay.append(item6)
        play3.visiPlay.append(item6)
        play3.homePlay.append(item6)
        play3.visiPlay.append(item6)
        play3.homePlay.append(item6)
        play3.visiPlay.append(item6)
        play3.homePlay.append(item6)
        play3.visiPlay.append(item6)
        play3.homePlay.append(item6)
        play3.visiPlay.append(item6)
        
        
        var play5 = LoLPlayData()
        play5.title = "获\n得\n一\n血"
        play5.playType = "4"
        var item7 = LoLPlayItemData()
        item7.title = "地图4"
        item7.odds = "9.1"
        play5.homePlay.append(item7)
        play5.visiPlay.append(item7)
        play5.homePlay.append(item7)
        play5.visiPlay.append(item7)
        play5.homePlay.append(item7)
        play5.visiPlay.append(item7)
        play5.homePlay.append(item7)
        play5.visiPlay.append(item7)
        play5.homePlay.append(item7)
        play5.visiPlay.append(item7)
        
        
        var play6 = LoLPlayData()
        play6.title = "摧毁首个\n防御塔"
        play6.playType = "5"
        var item8 = LoLPlayItemData()
        item8.title = "LGD"
        item8.odds = "9.1"
        var item9 = LoLPlayItemData()
        item9.title = "RNG"
        item9.odds = "7.1"
        play6.homePlay.append(item8)
        play6.visiPlay.append(item9)
        
        var play7 = LoLPlayData()
        play7.title = "摧毁首个\n水晶"
        play7.playType = "6"
        var item71 = LoLPlayItemData()
        item71.title = "LGD"
        item71.odds = "9.1"
        var item72 = LoLPlayItemData()
        item72.title = "RNG"
        item72.odds = "7.1"
        play7.homePlay.append(item71)
        play7.visiPlay.append(item72)
        
        var play8 = LoLPlayData()
        play8.title = "击杀首个\n大龙"
        play8.playType = "7"
        var item81 = LoLPlayItemData()
        item81.title = "LGD"
        item81.odds = "9.1"
        var item82 = LoLPlayItemData()
        item82.title = "RNG"
        item82.odds = "7.1"
        play8.homePlay.append(item81)
        play8.visiPlay.append(item82)
        
        var play9 = LoLPlayData()
        play9.title = "击杀首个\n小龙"
        play9.playType = "8"
        var item91 = LoLPlayItemData()
        item91.title = "LGD"
        item91.odds = "9.1"
        var item92 = LoLPlayItemData()
        item92.title = "RNG"
        item92.odds = "7.1"
        play9.homePlay.append(item91)
        play9.visiPlay.append(item92)
        
        mo1.play.append(play1)
        mo1.play.append(play2)
        mo1.play.append(play3)
        mo1.play.append(play4)
        mo1.play.append(play5)
        mo1.play.append(play6)
        mo1.play.append(play7)
        mo1.play.append(play8)
        mo1.play.append(play9)
        
        
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
//        mo1.play.append(play3)
//        mo1.play.append(play4)
//        mo1.play.append(play5)
        mo2.play.append(play1)
        mo2.play.append(play2)
//        mo1.play.append(play3)
//        mo1.play.append(play4)
//        mo1.play.append(play5)
        
        mo3.play.append(play1)
        mo3.play.append(play2)
//        mo1.play.append(play3)
//        mo1.play.append(play4)
//        mo1.play.append(play5)
        mo3.play.append(play1)
        mo3.play.append(play2)
//        mo1.play.append(play3)
//        mo1.play.append(play4)
//        mo1.play.append(play5)
        
        
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
