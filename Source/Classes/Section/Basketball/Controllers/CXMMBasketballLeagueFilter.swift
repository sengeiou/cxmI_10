//
//  CXMMBasketballLeagueFilter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/19.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


protocol CXMMBasketballLeagueFilterDelegate {
    func filterConfirm(leagueId: String) -> Void
}

class CXMMBasketballLeagueFilter: BasePopViewController {
    
    public var delegate : CXMMBasketballLeagueFilterDelegate!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var allSelect : UIButton!
    @IBOutlet weak var reverse : UIButton!
    
    @IBOutlet weak var confirm : UIButton!
    @IBOutlet weak var cancel : UIButton!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    private var currentFilterList : [FilterModel]!
    
    public var filterList: [FilterModel]! {
        didSet{
            guard filterList != nil else { return }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
        // 保存当前选中的
        currentFilterList = [FilterModel]()
        DispatchQueue.global().async {
            guard self.filterList != nil else { return }
            for model in self.filterList {
                if model.isSelected {
                    self.currentFilterList.append(model)
                }
            }
        }
        
    }

    private func initSubview() {
        self.viewHeight = 266 * defaultScale
        
        self.bgView.removeFromSuperview()
        
        self.pushBgView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    @objc public override func backPopVC() {
        self.cancelClick(self.cancel)
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === self.pushBgView.superview {
            return true
        }
        if touch.view !== self.collectionView || touch.view !== self.pushBgView {
            return false
        }
        return true
    }
}

// MARK: - 点击事件
extension CXMMBasketballLeagueFilter {

    @IBAction func allSelectClick(_ sender: UIButton) {
        guard self.filterList != nil else { return }
        for  index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = true
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @IBAction func reverseClick(_ sender: UIButton) {
        guard self.filterList != nil else { return }
        for index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = !filter.isSelected
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        guard self.filterList != nil else { return }
        var idStr : String = ""
        var name : String = ""
        var i = 0
        for filter in self.filterList {
            if filter.isSelected == true {
                print(i)
                idStr += filter.leagueId + ","
                name += filter.leagueAddr + ","
            }
            i += 1
        }
        
        if idStr != "" {
            idStr.removeLast()
        }
        
        TongJi.log(.比赛筛选, label: name, att: .赛事)
        
        guard delegate != nil else { return }
        delegate.filterConfirm(leagueId: idStr)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global().async {
            if self.filterList != nil {
                for model in self.filterList {
                    model.isSelected = false
                }
                for model in self.currentFilterList {
                    model.isSelected = true
                }
            }
        }

    }
}

extension CXMMBasketballLeagueFilter : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterList[indexPath.row]
        filter.isSelected = !filter.isSelected
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let filter = filterList[indexPath.row]
        filter.isSelected = !filter.isSelected
        collectionView.reloadItems(at: [indexPath])
    }
}
extension CXMMBasketballLeagueFilter : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList != nil ? filterList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketballLeagueFilterItem", for: indexPath) as! BasketballLeagueFilterItem
        cell.configure(with: filterList[indexPath.row])
        
        return cell
    }
    
}
extension CXMMBasketballLeagueFilter : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: BasketballLeagueFilterItem.width, height: BasketballLeagueFilterItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

