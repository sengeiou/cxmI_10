//
//  LoLPlayConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

protocol LoLPlayConfirmCellProtocol {
    func delete(view : LoLPlayConfirmCell, index : Int) -> Void
}

class LoLPlayConfirmCell: UITableViewCell {

    public var delegate : LoLPlayConfirmCellProtocol!
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var delete : UIButton!
    
    @IBOutlet weak var homeTeam : UILabel!
    @IBOutlet weak var visiTeam : UILabel!
    
    @IBAction func delete(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.delete(view: self, index: sender.tag)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   

}

extension LoLPlayConfirmCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension LoLPlayConfirmCell : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoLPlayConfirmSubCell", for: indexPath) as! LoLPlayConfirmSubCell
        
        
        
        return cell
    }
}
