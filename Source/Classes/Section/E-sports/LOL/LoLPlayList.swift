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
        }
    }
}

// MARK: - 点击事件
extension LoLPlayList {
    @IBAction func confirm(sender : UIButton) {
        
    }
    @IBAction func delete(sender : UIButton) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLPlayCell", for: indexPath) as! LoLPlayCell
        
        let play = viewModel.data.play[indexPath.section]
        
        cell.homeTeam.text = play.title
        cell.visiTeam.text = play.title
        return cell
    }
}


extension LoLPlayList {
    private func initSubview() {
        tableView.backgroundColor = ColorFFFFFF
    }
}
