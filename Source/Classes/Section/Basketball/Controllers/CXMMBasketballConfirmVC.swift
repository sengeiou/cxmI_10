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
    
    public var viewModel : BBConfirmViewModel! = BBConfirmViewModel()
    
    private var requestModel : BasketballRequestMode!
    
    private var getBetInfoModel : BBGetBetInfoModel!
    
    private var obser : Observable<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "投注确认"
        initSubview()
        setData()
        self.tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for play in viewModel.sePlayList {
            play.confirmViewModel = nil
        }
        
        viewModel = nil
    }
    
    deinit {
        
        
        
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
        
        _ = viewModel.shouldRequest.asObserver()
            .subscribe({ [weak self](event) in
                self?.getBetInfoRequest()
            }).disposed(by: disposeBag)
    }
    
    private func setBetInfo() {
        betInfo.text = "\(getBetInfoModel.betNum)注\(getBetInfoModel.times)倍 共需: \(getBetInfoModel.money)"
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
        changeConfirmButton(canTip: false)
        saveBetInfoRequest()
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

// MARK: - 胜分差， 混合投注，弹窗  delegate
extension CXMMBasketballConfirmVC : BasketballSFCPlayPopDelegate{
    func didTipConfirm(section : Int) {
        self.tableView.reloadSections(IndexSet(integer: section), with: .none)
        getBetInfoRequest()
    }
    func didTipDelete(section: Int) {
        getBetInfoRequest()
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
            cell.configure(with: viewModel.sePlayList[indexPath.section], viewMo: self.viewModel)
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

// MARK: - 网络请求
extension CXMMBasketballConfirmVC {
    private func loadNewData() {
        
    }
    private func getBetInfoRequest() {
        self.setRequestModel()
        
//        guard requestModel.matchBetPlays.count > 1 else { return }
        
        weak var weakSelf = self
        showProgressHUD()
        _ = basketBallProvider.rx.request(.getBetInfo(requestModel: self.requestModel))
            .asObservable()
            .mapObject(type: BBGetBetInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.dismissProgressHud()
                weakSelf?.getBetInfoModel = data
                weakSelf?.setBetInfo()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
            .disposed(by: disposeBag)
    }
    
    private func saveBetInfoRequest() {
        self.setRequestModel()
        weak var weakSelf = self
        showProgressHUD()
        _ = basketBallProvider.rx.request(.saveBetInfo(requestModel: self.requestModel))
            .asObservable()
            .mapObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.dismissProgressHud()
                
                weakSelf?.changeConfirmButton(canTip: true)
                let vc = CXMPaymentViewController()
                vc.lottoToken = data.data
                
                self.pushViewController(vc: vc)
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.dismissProgressHud()
                weakSelf?.changeConfirmButton(canTip: true)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
            .disposed(by: disposeBag)
    }
    
    private func changeConfirmButton( canTip : Bool) {
        switch canTip {
        case true:
            self.confirmBut.isUserInteractionEnabled = true
            self.confirmBut.backgroundColor = ColorE85504
        case false:
            self.confirmBut.isUserInteractionEnabled = false
            self.confirmBut.backgroundColor = ColorC7C7C7
        }
    }
}

extension CXMMBasketballConfirmVC {
    private func setRequestModel() {
        self.requestModel = BasketballRequestMode()
        
        if let betType = try? viewModel.betNum.value() {
            requestModel.betType = betType
        }
        if let times = try? viewModel.multiple.value() {
            requestModel.times = times
        }
        requestModel.lotteryClassifyId = viewModel.lotteryClassifyId
        requestModel.lotteryPlayClassifyId = viewModel.lotteryPlayClassifyId
        requestModel.playType = "1"
        
        var matchBetPlays = [BBMatchBetPlay]()
        
        for playInfo in viewModel.sePlayList {
            var matchBetPlay = BBMatchBetPlay()
            
            if let isDan = try? playInfo.isDan.value() {
                matchBetPlay.isDan = isDan
            }
            
            matchBetPlay.changci = playInfo.changci
        
            matchBetPlay.lotteryClassifyId = viewModel.lotteryClassifyId
            matchBetPlay.lotteryPlayClassifyId = viewModel.lotteryPlayClassifyId
            matchBetPlay.matchId = playInfo.playInfo.matchId
            matchBetPlay.matchTeam = playInfo.playInfo.homeTeamAbbr + "VS" + playInfo.playInfo.visitingTeamAbbr
            matchBetPlay.matchTime = playInfo.playInfo.matchTime
            matchBetPlay.playCode = playInfo.playInfo.playCode
            matchBetPlay.changciId = playInfo.playInfo.changciId
            
            var matchBetCells = [BBMatchBetCell]()
            
            // 胜负
            if playInfo.shengfu.isShow && (playInfo.shengfu.visiCell.selected
                                        || playInfo.shengfu.homeCell.selected) {
                var matchBetCell = BBMatchBetCell()
                var betCells = [BBCellModel]()
                if playInfo.shengfu.visiCell.selected {
                    
//                    var cell = BBBetCell()
//                    cell.cellName = playInfo.shengfu.visiCell.cellName
//                    cell.cellOdds = playInfo.shengfu.visiCell.cellOdds
//                    cell.cellCode = playInfo.shengfu.visiCell.cellCode
                    
                    
//                    betCells.append(cell)
                    betCells.append(playInfo.shengfu.visiCell)
                }
                if playInfo.shengfu.homeCell.selected {
//                    var cell = BBBetCell()
//                    cell.cellName = playInfo.shengfu.homeCell.cellName
//                    cell.cellOdds = playInfo.shengfu.homeCell.cellOdds
//                    cell.cellCode = playInfo.shengfu.homeCell.cellCode
//
//
//                    betCells.append(cell)
//                    betCells.append(playInfo.shengfu.homeCell)
                }
                
                matchBetCell.betCells = betCells
                matchBetCell.playType = "1"
                matchBetCell.single = playInfo.shengfu.single
                matchBetCell.fixedOdds = "0"
                matchBetCells.append(matchBetCell)
            }
            
            // 让分胜负
            if playInfo.rangfen.isShow && (playInfo.rangfen.visiCell.selected
                                        || playInfo.rangfen.homeCell.selected) {
                var matchBetCell = BBMatchBetCell()
                var betCells = [BBCellModel]()
                if playInfo.rangfen.visiCell.selected {
                    betCells.append(playInfo.rangfen.visiCell)
                }
                if playInfo.rangfen.homeCell.selected {
                    betCells.append(playInfo.rangfen.homeCell)
                }
                
                matchBetCell.betCells = betCells
                matchBetCell.playType = "2"
                matchBetCell.single = playInfo.rangfen.single
                matchBetCell.fixedOdds = playInfo.rangfen.fixOdds
                matchBetCells.append(matchBetCell)
            }
            // 大小分
            if playInfo.daxiaofen.isShow && (playInfo.daxiaofen.visiCell.selected
                                            || playInfo.daxiaofen.homeCell.selected) {
                var matchBetCell = BBMatchBetCell()
                var betCells = [BBCellModel]()
                if playInfo.daxiaofen.visiCell.selected {
                    betCells.append(playInfo.daxiaofen.visiCell)
                }
                if playInfo.daxiaofen.homeCell.selected {
                    betCells.append(playInfo.daxiaofen.homeCell)
                }
                
                matchBetCell.betCells = betCells
                matchBetCell.playType = "4"
                matchBetCell.single = playInfo.daxiaofen.single
                matchBetCell.fixedOdds = playInfo.daxiaofen.fixOdds
                matchBetCells.append(matchBetCell)
            }
            // 胜分差
            if playInfo.shengFenCha.isShow && (playInfo.playType == .混合投注
                                            || playInfo.playType == .胜分差){
                var matchBetCell = BBMatchBetCell()
                var betCells = [BBCellModel]()

                for cell in playInfo.shengFenCha.visiSFC {
                    if cell.selected {
                        betCells.append(cell)
                    }
                }
                
                for cell in playInfo.shengFenCha.homeSFC {
                    if cell.selected {
                        betCells.append(cell)
                    }
                }
                
                matchBetCell.betCells = betCells
                matchBetCell.playType = "3"
                matchBetCell.single = playInfo.daxiaofen.single
                matchBetCell.fixedOdds = playInfo.daxiaofen.fixOdds
                matchBetCells.append(matchBetCell)
            }
            
            matchBetPlay.matchBetCells = matchBetCells
            matchBetPlays.append(matchBetPlay)
        }
        
        requestModel.matchBetPlays = matchBetPlays
    }
}
