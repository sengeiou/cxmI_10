//
//  ESportsLoLPlayList.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/27.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class LoLPlayList: BaseViewController {

    public var defData : LoLData!
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var confirm : UIButton!
    @IBOutlet weak var delete : UIButton!
    
    @IBOutlet weak var homeTeam : UILabel!
    @IBOutlet weak var visiTeam : UILabel!
    
    public var viewModel : LoLPlayModel = LoLPlayModel()
    
    private var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "玩法投注"
        initSubview()
        
        
        setData()
        self.tableView.reloadData()
    }

}

// MARK: - 设置数据
extension LoLPlayList {
    private func setData() {
//        viewModel.setData(data: defData)
        
//        viewModel.homeTeam.bind(to: homeTeam.rx.text).disposed(by: bag)
//        viewModel.visiTeam.bind(to: visiTeam.rx.text).disposed(by: bag)
        
        homeTeam.text = viewModel.homeTeam
        visiTeam.text = viewModel.visiTeam
        
        viewModel.reloadData.subscribe { (event) in
            self.tableView.reloadData()
        }.disposed(by: bag)
    }
}

// MARK: - 点击事件
extension LoLPlayList {
    @IBAction func confirm(sender : UIButton) {
        viewModel.confirm()
        self.popViewController()
    }
    @IBAction func delete(sender : UIButton) {
        viewModel.removeAllSelect()
    }
}

extension LoLPlayList : LoLPlayCellProtocol, ESPortsCollectionCellProtocol {
    func didTipItem(view : LoLPlayCell, type : ItemType, section : Int) {
        viewModel.sePlayItem(play: viewModel.list[section], type : type, index: 0)
    }
    func didTipItem(view: ESPortsCollectionCell, type: ItemType, section: Int, index: Int) {
        viewModel.sePlayItem(play: viewModel.list[section], type : type, index: index)
    }
}

extension LoLPlayList : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return viewModel.list[indexPath.section].cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

extension LoLPlayList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let play = viewModel.list[indexPath.section]
        
        if play.homeItems.count == 1 {
            return initPlayCell(indexPath: indexPath)
        }else {
            return initPlayCollectionCell(indexPath: indexPath)
        }
    }
    
    private func initPlayCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLPlayCell", for: indexPath) as! LoLPlayCell
        cell.delegate = self
        cell.tag = indexPath.section
        
        let play = viewModel.list[indexPath.section]
        
        cell.title.text = play.title
        cell.title.backgroundColor = play.titleBgColor
        let item1 = play.homeItems[0]
        let item2 = play.visiItems[0]
        
        item1.attText.bind(to: cell.homeOdds.rx.attributedTitle()).disposed(by: cell.bag)
        item2.attText.bind(to: cell.visiOdds.rx.attributedTitle()).disposed(by: cell.bag)
        
        
        item1.itemBackgroundColor.bind(to: cell.homeOdds.rx.backgroundColor()).disposed(by: cell.bag)
        item2.itemBackgroundColor.bind(to: cell.visiOdds.rx.backgroundColor()).disposed(by: cell.bag)
        
        return cell
    }
    
    private func initPlayCollectionCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ESPortsCollectionCell", for: indexPath) as! ESPortsCollectionCell
        cell.delegate = self
        cell.tag = indexPath.section
        
        let play = viewModel.list[indexPath.section]
        cell.title.text = play.title
        cell.title.backgroundColor = play.titleBgColor
        cell.playModel = viewModel.list[indexPath.section]
        
        return cell
    }
    
}

// MARK: - 初始化
extension LoLPlayList {
    private func initSubview() {
        tableView.backgroundColor = ColorFFFFFF
        setRightNav()
    }
    private func setRightNav() {
        let right = UIButton(type: .custom)
        right.setTitle("帮助", for: .normal)
        right.setTitleColor(Color505050, for: .normal)
        right.addTarget(self, action: #selector(rightNavItem(sender:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right)
    }
    
    @objc private func rightNavItem( sender : UIButton ) {
        
    }
}
