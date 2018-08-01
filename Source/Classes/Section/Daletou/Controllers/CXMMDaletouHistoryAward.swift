//
//  CXMMDaletouHistoryAward.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouHistoryAward: BasePopViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }

    private func initSubview() {
        self.viewHeight = 400 * defaultScale
        
        self.pushBgView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DaletouHistoryAwardCell.identifier, for: indexPath) as! DaletouHistoryAwardCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * defaultScale
    }
    
}
