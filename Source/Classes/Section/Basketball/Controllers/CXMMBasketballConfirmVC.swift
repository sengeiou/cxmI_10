//
//  CXMMBasketballConfirmVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMBasketballConfirmVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    /// 已选比赛数
    @IBOutlet weak var topLabel : UILabel!
    /// 串关
    @IBOutlet weak var chuanGuanButton : UIButton!
    /// 倍数
    @IBOutlet weak var multipleButton : UIButton!
    /// 投注信息
    @IBOutlet weak var betInfo : UILabel!
    /// 确认
    @IBOutlet weak var confirmBut : UIButton!
    
    private var disposeBag = DisposeBag()
    
    public var viewModel : BasketballViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "投注确认"
        initSubview()
        setData()
        self.tableView.reloadData()
    }

    private func setData() {
        _ = viewModel.multiple.asObserver()
            .subscribe({ [weak self](event) in
                guard let multiple = event.element else { return }
                self?.multipleButton.setTitle("倍数 \(multiple)倍", for: .normal)
            })
            .disposed(by: disposeBag)
        
        _ = viewModel.confirmButtonState.asObserver()
            .subscribe({ [weak self](event) in
                guard let canNext = event.element else { return }
                self?.confirmBut.isUserInteractionEnabled = canNext

                switch canNext{
                case true :
                    self?.confirmBut.backgroundColor = ColorEA5504
                case false:
                    self?.confirmBut.backgroundColor = ColorC7C7C7
                }

            }).disposed(by: disposeBag)
        
        _ = viewModel.betTitle.asObserver()
            .subscribe({ [weak self](event) in
                guard let betTitle = event.element else { return }
                self?.chuanGuanButton.setTitle(betTitle, for: .normal)
            }).disposed(by: disposeBag)
    }
    private func initSubview() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorEDEDED
    }

}
// MARK: - 代理
extension CXMMBasketballConfirmVC : FootballTimesFilterVCDelegate, FootballPlayFilterVCDelegate {
    // 串关
    func playFilterConfirm(filterList: [FootballPlayFilterModel]) {
        viewModel.changChuanguan()
    }
    
    func playFilterCancel() {
        
    }
    
    // 倍数
    func timesConfirm(times: String) {
        viewModel.changeMultiple(multiple: times)
    }
    
    
}
// MARK: - 点击事件
extension CXMMBasketballConfirmVC {
    // 串关
    @IBAction func chuanGuanClick(_ sender : UIButton) {
        let chuanguan = CXMFootballPlayFilterVC()
        chuanguan.delegate = self
        chuanguan.filterList = viewModel.getFilterList()
        present(chuanguan)
    }
    // 倍数
    @IBAction func multipleClick(_ sender : UIButton) {
        let multiple = CXMFootballTimesFilterVC()
        multiple.delegate = self
        if let times = try? viewModel.multiple.value() {
            multiple.times = times
        }
        present(multiple)
    }
    // 确认
    @IBAction func confirmClick(_ sender : UIButton) {
        
    }
}
// MARK: - CELL Delegate
extension CXMMBasketballConfirmVC : BasketballConfirmCellDelegate {
    func didTipDan(playInfo: BBPlayModel) {
        viewModel.setDan(play: playInfo)
    }
    
    func didTipDelete(playInfo: BBPlayModel) {
        viewModel.deletePlay(play: playInfo)
        tableView.reloadData()
    }
    
}

// MARK: - 胜分差，选取 delegate
extension CXMMBasketballConfirmVC : BasketballSFCPlayPopDelegate{
    func didTipConfirm(section : Int) {
        self.tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
}

// MARK: - tableview Delegate
extension CXMMBasketballConfirmVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.sePlayList[indexPath.section]
        
        switch model.playType {
        case .混合投注:
            let story = UIStoryboard(storyboard: .Basketball)
            
            let hunhePlay = story.instantiateViewController(withIdentifier: "BasketballHunhePlayPop") as! CXMMBasketballHunhePlayPop
            hunhePlay.delegate = self
            hunhePlay.section = indexPath.section
            hunhePlay.configure(with: model)
            
            hunhePlay.configure(with: model.playInfo)
            present(hunhePlay)
        case .胜分差:
            let story = UIStoryboard(storyboard: .Basketball)
            
            let shengFenPlay = story.instantiateViewController(withIdentifier: "BasketballSFCPlayPop") as! CXMMBasketballSFCPlayPop
            shengFenPlay.delegate = self
            shengFenPlay.section = indexPath.section
            shengFenPlay.configure(with: model.playInfo)
            shengFenPlay.configure(with: model)
            present(shengFenPlay)
        case .胜负, .让分胜负, .大小分:
            break
        }
    }
}
// MARK: - tableview DataSource
extension CXMMBasketballConfirmVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sePlayList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel.sePlayList[indexPath.section]
        
        switch model.playType {
        case .混合投注, .胜分差:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballConfirmSFCCell", for: indexPath) as! BasketballConfirmSFCCell
            cell.delegate = self
            cell.configure(with: viewModel.sePlayList[indexPath.section])
            return cell
        case .胜负, .让分胜负, .大小分:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballConfirmCell", for: indexPath) as! BasketballConfirmCell
            cell.delegate = self
            cell.configure(with: viewModel.sePlayList[indexPath.section])
            return cell
        }
    }
}
extension CXMMBasketballConfirmVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = viewModel.sePlayList[indexPath.section]
        
        switch model.playType {
        case .混合投注, .胜分差:
            return UITableViewAutomaticDimension
        case .胜负, .让分胜负, .大小分:
            return 150
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section + 1 == viewModel.sePlayList.count {
            return 0.01
        }
        return 5
    }
}
