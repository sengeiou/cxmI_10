//
//  SurpriseViewController.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import UIKit


class CXMMSurpriseViewController: BaseViewController{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
}

extension CXMMSurpriseViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CXMMSurpriseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMSurpriseViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseCollectionCell", for: indexPath) as! SurpriseCollectionCell
        
        return cell
    }
}

extension CXMMSurpriseViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let newsInfo = newsList[indexPath.row]
//
//        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
//            return initNewsOnePicCell(indexPath: indexPath)
//        }else if newsInfo.listStyle == "3" {
//            return initNewsThreePicCell(indexPath: indexPath)
//        }else {
//            return initNewsNoPicCell(indexPath: indexPath)
//        }
        
        return initNewsOnePicCell(indexPath: indexPath)
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCell.identifier, for: indexPath) as! NewsNoPicCell
        
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCell.identifier, for: indexPath) as! NewsThreePicCell
        
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCell.identifier, for: indexPath) as! NewsOnePicCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
//        let newsInfo = newsList[indexPath.row]
//        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
//            return 110 * defaultScale
//        }
//        else {
//            return 150 * defaultScale
//        }
        
        return 110 * defaultScale
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
