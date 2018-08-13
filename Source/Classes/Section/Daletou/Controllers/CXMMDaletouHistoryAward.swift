//
//  CXMMDaletouHistoryAward.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouHistoryAward: BasePopViewController {

    public var prizeList : [DLTHistoricalData]! {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private var titleLabel : UILabel!
    private var line : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }

    private func initSubview() {
        self.viewHeight = 400 * defaultScale
        
        titleLabel = UILabel()
        titleLabel.font = Font14
        titleLabel.textColor = Color505050
        titleLabel.textAlignment = .center
        titleLabel.text = "历史开奖"
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        
        self.pushBgView.addSubview(titleLabel)
        self.pushBgView.addSubview(line)
        self.pushBgView.addSubview(tableView)
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(line.snp.bottom)
        }
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(DaletouHistoryAwardCell.self,
                       forCellReuseIdentifier: DaletouHistoryAwardCell.identifier)
        table.separatorColor = ColorE9E9E9
        return table
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CXMMDaletouHistoryAward : UITableViewDelegate {
    
}

extension CXMMDaletouHistoryAward : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prizeList != nil ? self.prizeList.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DaletouHistoryAwardCell.identifier, for: indexPath) as! DaletouHistoryAwardCell
        
        cell.configure(with: prizeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * defaultScale
    }
    
}
