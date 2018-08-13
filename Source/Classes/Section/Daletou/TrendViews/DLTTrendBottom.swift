//
//  DLTTrendBottom.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTTrendBottom: UIView , AlertPro{
    @IBOutlet weak var redCollectionView : UICollectionView!
    @IBOutlet weak var blueCollectionView : UICollectionView!
    
    @IBOutlet weak var detailLabel : UILabel!
    
    @IBOutlet weak var confirmBut : UIButton!
    
    @IBOutlet weak var deleteBut : UIButton!
    
    public var viewModel : DLTTrendBottomModel!
    
    private var redList : [DaletouDataModel]!
    private var blueList : [DaletouDataModel]!
    
    private var seRedSet = Set<DaletouDataModel>()
    private var seBluSet = Set<DaletouDataModel>()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension DLTTrendBottom {
    private func setData() {
        guard viewModel != nil else { return }
        _ = viewModel.betNum.asObserver().subscribe(onNext: { (num) in
            guard num * 2 <= 20000 else {
                self.showHUD(message: "单次投注最多2万元")
                return 
            }
            if num > 0 {
                let att = NSMutableAttributedString(string: "共")
                let numAtt = NSAttributedString(string: "\(num)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let defa = NSAttributedString(string: "注 合计")
                let money = NSAttributedString(string: "\(num * 2)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let yuan = NSAttributedString(string: "元")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                att.append(yuan)
                self.detailLabel.attributedText = att
                self.confirmBut.backgroundColor = ColorE85504
                self.confirmBut.isUserInteractionEnabled = true
            }else {
                let att = NSMutableAttributedString(string: "请至少选择")
                
                let numAtt = NSAttributedString(string: "\(5)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let defa = NSAttributedString(string: "个红球")
                let money = NSAttributedString(string: "2", attributes: [NSAttributedStringKey.foregroundColor: Color0081CC])
                let defa1 = NSAttributedString(string: "个篮球")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                att.append(defa1)
                self.detailLabel.attributedText = att
                self.confirmBut.backgroundColor = ColorC7C7C7
                self.confirmBut.isUserInteractionEnabled = false
            }
            
        }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = viewModel.reloadData.asObserver()
            .subscribe(onNext: { (reload) in
                if reload {
                    self.redCollectionView.reloadData()
                    self.blueCollectionView.reloadData()
                }
            }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        
    }
}

extension DLTTrendBottom {
    public func configure(red : [DaletouDataModel], blue : [DaletouDataModel]) {
        setData()
        self.redList = red
        self.blueList = blue
        
        self.redCollectionView.reloadData()
        self.blueCollectionView.reloadData()
    }
}

extension DLTTrendBottom : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.redCollectionView {
            redList[indexPath.row].selected = !redList[indexPath.row].selected
            viewModel.selected(model: redList[indexPath.row])
        }else if collectionView == self.blueCollectionView {
            blueList[indexPath.row].selected = !blueList[indexPath.row].selected
            viewModel.selected(model: blueList[indexPath.row])
        }
    }
}

extension DLTTrendBottom : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.redCollectionView {
            return redList != nil ? redList.count : 0
        }
        else if collectionView == self.blueCollectionView {
            return blueList != nil ? blueList.count : 0
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTTrendBallItem", for: indexPath) as! DLTTrendBallItem
        
        if collectionView == self.redCollectionView {
            cell.configure(with: redList[indexPath.row])
        }
        else if collectionView == self.blueCollectionView {
            cell.configure(with: blueList[indexPath.row])
        }
        
        
        return cell
    }
    
    
}

extension DLTTrendBottom : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DLTTrendBallItem.width, height: DLTTrendBallItem.heiht)
    }
}
