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
    
    private var viewModel : LoLPlayModel = LoLPlayModel()
    
    private var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "玩法投注"
        initSubview()
        
        
        setData()
    }

}

// MARK: - 设置数据
extension LoLPlayList {
    private func setData() {
        viewModel.setData(data: defData)
        
        viewModel.homeTeam.bind(to: homeTeam.rx.text).disposed(by: bag)
        viewModel.visiTeam.bind(to: visiTeam.rx.text).disposed(by: bag)
        
        viewModel.reloadData.subscribe { (event) in
            self.tableView.reloadData()
        }.disposed(by: bag)
    }
}

// MARK: - 点击事件
extension LoLPlayList {
    @IBAction func confirm(sender : UIButton) {
        
    }
    @IBAction func delete(sender : UIButton) {
        
    }
}

extension LoLPlayList : LoLPlayCellProtocol {
    func didTipHome(view: LoLPlayCell, index: Int) {
        viewModel.sePlayItem(playItem: viewModel.list[index], index: 0)
    }
    
    func didTipVisi(view: LoLPlayCell, index: Int) {
        viewModel.sePlayItem(playItem: viewModel.list[index], index: 1)
    }
}

extension LoLPlayList : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
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
        return viewModel.data.play.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initPlayCollectionCell(indexPath: indexPath)
        default:
            return initPlayCell(indexPath: indexPath)
        }
    }
    
    
    private func initPlayCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLPlayCell", for: indexPath) as! LoLPlayCell
        cell.delegate = self
        
        let play = viewModel.list[indexPath.section]
        
        play.title.bind(to: cell.title.rx.text).disposed(by: cell.bag)
        
        let item1 = play.items[0]
        let item2 = play.items[1]
        
        item1.text.bind(to: cell.homeOdds.rx.title()).disposed(by: cell.bag)
        item2.text.bind(to: cell.visiOdds.rx.title()).disposed(by: cell.bag)
        
        
        cell.tag = indexPath.section
        item1.itemBackgroundColor.bind(to: cell.homeOdds.rx.backgroundColor()).disposed(by: cell.bag)
        item2.itemBackgroundColor.bind(to: cell.visiOdds.rx.backgroundColor()).disposed(by: cell.bag)
        
        return cell
    }
    
    private func initPlayCollectionCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ESPortsCollectionCell", for: indexPath) as! ESPortsCollectionCell
        
        cell.playModel = viewModel.list[indexPath.section]
        
        return cell
    }
    
}


extension LoLPlayList {
    private func initSubview() {
        tableView.backgroundColor = ColorFFFFFF
    }
}
