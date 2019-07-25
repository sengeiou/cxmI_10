//
//  CXMMBasketballVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

enum BasketballPlayType : String {
    case 让分胜负
    case 胜负
    case 胜分差
    case 大小分
    case 混合投注 
    
    static func getPlayType (type : BasketballPlayType) -> String {
        switch type {
        case .胜负:
            return "2"
        case .大小分:
            return "4"
        case .胜分差:
            return "3"
        case .让分胜负:
            return "1"
        case .混合投注:
            return "6"
        }
    }
    
}

fileprivate var maxNum: Set<Int> = [8]

class CXMMBasketballVC: BaseViewController {

    @IBOutlet weak var totalMatch : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var deleteBut : UIButton!
    @IBOutlet weak var selectNum : UILabel!
    @IBOutlet weak var confirmBut: UIButton!
    
    public var type : BasketballPlayType = .混合投注 {
        didSet{
            guard titleView != nil else { return }
            titleView.setTitle(type.rawValue, for: .normal)
        }
    }
    
    private var menu : CXMMBasketballMenu = CXMMBasketballMenu()
    public var titleView : UIButton!
    public var titleIcon : UIImageView!
    
    private var matchModel : BasketballDataModel!
    private var filterList : [FilterModel]!
    private var hasHot : Bool = false
    
    private var viewModel : BasketballViewModel = BasketballViewModel()
    
    private var playViewModel : BBPlayViewModel = BBPlayViewModel()
    
    private var disposeBag : DisposeBag = DisposeBag()
    // MARK : - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightButtonItem()
        initSubview()
        setData()
        filterRequest()
//        tableView.headerRefresh {
            self.loadNewData()
//        }
//        tableView.beginRefreshing()
    }
    // MARK: - 设置显示数据
    private func setData() {
        _ = viewModel.selectNumText.asObserver()
            .subscribe { [weak self](event) in
                guard let text = event.element else { return }
                self?.selectNum.text = text
        }.disposed(by: disposeBag)
        
        // 确定按钮显示 样式
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
    }
    private func initSubview() {
        menu.delegate = self
        setNavigationTitleView()
        self.view.addSubview(menu)
        tableView.separatorStyle = .none
        
        tableView.register(BasketBallHotSectionHeader.self,
                           forHeaderFooterViewReuseIdentifier: BasketBallHotSectionHeader.identifier)
        tableView.register(BasketBallSectionHeader.self,
                           forHeaderFooterViewReuseIdentifier: BasketBallSectionHeader.identifier)
    }

    // MARK: - right bar item
    private func setRightButtonItem() {
        
        let rightBut = UIButton(type: .custom)
        rightBut.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        //rightBut.setBackgroundImage(UIImage(named:"filter"), for: .normal)
        
        rightBut.setImage(UIImage(named:"filter"), for: .normal)
        rightBut.imageEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        rightBut.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        
        let helpBut = UIButton(type: .custom)
        helpBut.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        helpBut.setTitle("帮助", for: .normal)
        helpBut.setTitleColor(ColorNavItem, for: .normal)
        helpBut.addTarget(self, action: #selector(helpClicked(_:)), for: .touchUpInside)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBut)
        let rightItem = UIBarButtonItem(customView: rightBut)
        let helpItem = UIBarButtonItem(customView: helpBut)
        self.navigationItem.rightBarButtonItems = [helpItem, rightItem]
    }
    
    // MARK: - 帮助
    @objc private func helpClicked(_ sender: UIButton) {
        TongJi.log(.帮助, label: self.type.rawValue, att: .彩种)
        let homeWeb = CXMWebViewController()
        homeWeb.urlStr = getCurentBaseWebUrl() + webPlayHelp
        pushViewController(vc: homeWeb)
    }
    @objc private func showMenu(_ sender: UIButton) {
        TongJi.log(.赛事筛选, label: self.type.rawValue, att: .彩种)
        
        let story = UIStoryboard(storyboard: .Basketball)
        
        let filter = story.instantiateViewController(withIdentifier: "BasketballLeagueFilter") as! CXMMBasketballLeagueFilter
        filter.delegate = self
        filter.filterList = filterList
        present(filter)
    }
    
}
// MARK: - 网络请求
extension CXMMBasketballVC {
    private func loadNewData() {
        basketballRequest("")
    }
    private func basketballRequest(_ leagueId : String) {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = basketBallProvider.rx.request(.basketballMatchList(leagueId: leagueId,
                                                               playType: BasketballPlayType.getPlayType(type: self.type)))
            .asObservable()
            .mapObject(type: BasketballMatchList.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.matchModel = BasketballDataModel()
                weakSelf?.matchModel.allMatchCount = data.allMatchCount
                weakSelf?.matchModel.list = data.playList
                weakSelf?.matchModel.lotteryClassifyId = data.lotteryClassifyId
                weakSelf?.matchModel.lotteryPlayClassifyId = data.lotteryPlayClassifyId
                
                weakSelf?.viewModel.lotteryClassifyId = data.lotteryClassifyId
                weakSelf?.viewModel.lotteryPlayClassifyId = data.lotteryPlayClassifyId
                
                
                if data.hotPlayList.isEmpty == false {
                    let model = BasketballMatchModel()
                    model.title = "热门比赛"
                    model.playList = data.hotPlayList
                    weakSelf?.matchModel.list.insert(model, at: 0)
                    weakSelf?.hasHot = true
                }
                weakSelf?.totalMatch.text = "共有\(data.allMatchCount)场比赛可投注"
                
                self.playViewModel.list.removeAll()
                
                for model in (weakSelf?.matchModel.list)! {
                    let sectionModel = BBPlaySectionModel()
                    
                    for play in model.playList {
                        switch play.playType {
                        case "2":
                            let playInfo = BBPlayModel()
                            playInfo.viewModel = self.viewModel
                            
                            playInfo.changci = play.changci
                            playInfo.playType = .胜负
                            playInfo.visiTeam = play.visitingTeamAbbr
                            playInfo.homeTeam = play.homeTeamAbbr
                            playInfo.playInfo = play
                            for cell in play.matchPlays {
                                let cellInfo = BBPlayInfoModel()
                                cellInfo.single = cell.single
                                cellInfo.isShow = cell.isShow
                                cellInfo.fixOdds = cell.fixedOdds
                                
                                let homeCell = BBCellModel()
                                homeCell.playType = cell.playType
                            
                                if cell.isShow && cell.homeCell != nil {
                                    homeCell.cellName = cell.homeCell.cellName
                                    homeCell.cellOdds = cell.homeCell.cellOdds
                                    homeCell.cellCode = cell.homeCell.cellCode
                                }
                                
                                cellInfo.homeCell = homeCell
                                let visiCell = BBCellModel()
                                visiCell.playType = cell.playType
                                if cell.isShow && cell.visitingCell != nil {
                                    visiCell.cellName = cell.visitingCell.cellName
                                    visiCell.cellOdds = cell.visitingCell.cellOdds
                                    visiCell.cellCode = cell.visitingCell.cellCode
                                }
                                
                                cellInfo.visiCell = visiCell
                                
                                playInfo.shengfu = cellInfo
                            }
                            sectionModel.list.append(playInfo)
                        case "1":
                            let playInfo = BBPlayModel()
                            playInfo.viewModel = self.viewModel
                            
                            playInfo.changci = play.changci
                            playInfo.playType = .让分胜负
                            playInfo.visiTeam = play.visitingTeamAbbr
                            playInfo.homeTeam = play.homeTeamAbbr
                            playInfo.playInfo = play
                            
                            for cell in play.matchPlays {
                                let cellInfo = BBPlayInfoModel()
                                cellInfo.single = cell.single
                                cellInfo.isShow = cell.isShow
                                cellInfo.fixOdds = cell.fixedOdds
                                
                                let homeCell = BBCellModel()
                                homeCell.playType = cell.playType
                                if cell.isShow && cell.homeCell != nil {
                                    homeCell.cellName = cell.homeCell.cellName
                                    homeCell.cellOdds = cell.homeCell.cellOdds
                                    homeCell.cellCode = cell.homeCell.cellCode
                                }
                                
                                cellInfo.homeCell = homeCell
                                let visiCell = BBCellModel()
                                visiCell.playType = cell.playType
                                if cell.isShow && cell.visitingCell != nil {
                                    visiCell.cellName = cell.visitingCell.cellName
                                    visiCell.cellOdds = cell.visitingCell.cellOdds
                                    visiCell.cellCode = cell.visitingCell.cellCode
                                }
                                
                                cellInfo.visiCell = visiCell
                                
                                playInfo.rangfen = cellInfo
                            }
                            sectionModel.list.append(playInfo)
                        case "3":
                            let playInfo = BBPlayModel()
                            playInfo.viewModel = self.viewModel
                            
                            playInfo.changci = play.changci
                            playInfo.playType = .胜分差
                            playInfo.visiTeam = play.visitingTeamAbbr
                            playInfo.homeTeam = play.homeTeamAbbr
                            playInfo.playInfo = play
                            
                            for cell in play.matchPlays {
                                playInfo.shengFenCha.single = cell.single
                                playInfo.shengFenCha.isShow = cell.isShow
                                playInfo.shengFenCha.fixOdds = cell.fixedOdds
                                
                                if let visi = cell.visitingCell {
                                    for ce in visi.cellSons {
                                        let visiCell = BBCellModel()
                                        visiCell.cellName = ce.cellName
                                        visiCell.cellOdds = ce.cellOdds
                                        visiCell.cellCode = ce.cellCode
                                        visiCell.playType = "3"
                                        playInfo.shengFenCha.visiSFC.append(visiCell)
                                    }
                                }
                                if let home = cell.homeCell {
                                    for ce in home.cellSons {
                                        let homeCell = BBCellModel()
                                        homeCell.cellName = ce.cellName
                                        homeCell.cellOdds = ce.cellOdds
                                        homeCell.cellCode = ce.cellCode
                                        homeCell.playType = "3"
                                        playInfo.shengFenCha.homeSFC.append(homeCell)
                                    }
                                }
                            }
                            sectionModel.list.append(playInfo)
                            
                            break
                        case "4":
                            let playInfo = BBPlayModel()
                            playInfo.viewModel = self.viewModel
                            
                            playInfo.changci = play.changci
                            playInfo.playType = .大小分
                            playInfo.visiTeam = play.visitingTeamAbbr
                            playInfo.homeTeam = play.homeTeamAbbr
                            playInfo.playInfo = play
                            
                            for cell in play.matchPlays {
                                let cellInfo = BBPlayInfoModel()
                                cellInfo.single = cell.single
                                cellInfo.isShow = cell.isShow
                                cellInfo.fixOdds = cell.fixedOdds
                                
                                let homeCell = BBCellModel()
                                homeCell.playType = cell.playType
                                if cell.isShow && cell.homeCell != nil {
                                    homeCell.cellName = cell.homeCell.cellName
                                    homeCell.cellOdds = cell.homeCell.cellOdds
                                    homeCell.cellCode = cell.homeCell.cellCode
                                }
                                
                                cellInfo.homeCell = homeCell
                                let visiCell = BBCellModel()
                                visiCell.playType = cell.playType
                                if cell.isShow && cell.visitingCell != nil {
                                    visiCell.cellName = cell.visitingCell.cellName
                                    visiCell.cellOdds = cell.visitingCell.cellOdds
                                    visiCell.cellCode = cell.visitingCell.cellCode
                                }
                                
                                cellInfo.visiCell = visiCell
                                
                                playInfo.daxiaofen = cellInfo
                            }
                            sectionModel.list.append(playInfo)
                        case "6":
                            let playInfo = BBPlayModel()
                            playInfo.viewModel = self.viewModel
                            
                            playInfo.changci = play.changci
                            playInfo.playType = .混合投注
                            playInfo.visiTeam = play.visitingTeamAbbr
                            playInfo.homeTeam = play.homeTeamAbbr
                            playInfo.playInfo = play
                            
                            for cell in play.matchPlays {
                                let cellInfo = BBPlayInfoModel()
                                cellInfo.single = cell.single
                                cellInfo.isShow = cell.isShow
                                cellInfo.fixOdds = cell.fixedOdds
                                
                                let homeCell = BBCellModel()
                                homeCell.playType = cell.playType
                                cellInfo.homeCell = homeCell
                                
                                let visiCell = BBCellModel()
                                visiCell.playType = cell.playType
                                cellInfo.visiCell = visiCell
                                
                                switch cell.playType {
                                case "2":
                                    if cell.isShow && cell.homeCell != nil {
                                        homeCell.cellName = cell.homeCell.cellName
                                        homeCell.cellOdds = cell.homeCell.cellOdds
                                        homeCell.cellCode = cell.homeCell.cellCode
                                    }
                                    if cell.isShow && cell.visitingCell != nil {
                                        visiCell.cellName = cell.visitingCell.cellName
                                        visiCell.cellOdds = cell.visitingCell.cellOdds
                                        visiCell.cellCode = cell.visitingCell.cellCode
                                    }
                                    
                                    playInfo.shengfu = cellInfo
                                case "1":
                                    if cell.isShow && cell.homeCell != nil {
                                        homeCell.cellName = cell.homeCell.cellName
                                        homeCell.cellOdds = cell.homeCell.cellOdds
                                        homeCell.cellCode = cell.homeCell.cellCode
                                    }
                                    if cell.isShow && cell.visitingCell != nil {
                                        visiCell.cellName = cell.visitingCell.cellName
                                        visiCell.cellOdds = cell.visitingCell.cellOdds
                                        visiCell.cellCode = cell.visitingCell.cellCode
                                    }
                                    
                                    playInfo.rangfen = cellInfo
                                case "3":
                                    guard cell.visitingCell != nil else { break }
                                    guard cell.homeCell != nil else { break }
                                    for ce in cell.visitingCell.cellSons {
                                        let cellIn = BBCellModel()
                                        cellIn.cellName = ce.cellName
                                        cellIn.cellOdds = ce.cellOdds
                                        cellIn.cellCode = ce.cellCode
                                        cellIn.playType = "3"
                                        playInfo.shengFenCha.visiSFC.append(cellIn)
                                    }
                                    
                                    for ce in cell.homeCell.cellSons {
                                        let cellIn = BBCellModel()
                                        cellIn.cellName = ce.cellName
                                        cellIn.cellOdds = ce.cellOdds
                                        cellIn.cellCode = ce.cellCode
                                        cellIn.playType = "3"
                                        playInfo.shengFenCha.homeSFC.append(cellIn)
                                    }
                                case "4":
                                    if cell.isShow && cell.homeCell != nil {
                                        homeCell.cellName = cell.homeCell.cellName
                                        homeCell.cellOdds = cell.homeCell.cellOdds
                                        homeCell.cellCode = cell.homeCell.cellCode
                                    }
                                    if cell.isShow && cell.visitingCell != nil {
                                        visiCell.cellName = cell.visitingCell.cellName
                                        visiCell.cellOdds = cell.visitingCell.cellOdds
                                        visiCell.cellCode = cell.visitingCell.cellCode
                                    }
                                    
                                    playInfo.daxiaofen = cellInfo
                                default : break
                                }
                            }
                            sectionModel.list.append(playInfo)
                        default : break
                        }
                    }
                    self.playViewModel.list.append(sectionModel)
                    
                }
                weakSelf?.tableView.reloadData()
                self.dismissProgressHud()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
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
    }
    
    private func filterRequest() {
        weak var weakSelf = self
        _ = basketBallProvider.rx.request(.basketballFilterList())
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.filterList = data
                
            }, onError: { (error) in
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
    }
}
// MARK: - 筛选 代理
extension CXMMBasketballVC : CXMMBasketballLeagueFilterDelegate{
    func filterConfirm(leagueId: String) {
        basketballRequest(leagueId)
    }
}
// MARK: - 删除、确认，点击事件
extension CXMMBasketballVC {
    @IBAction func didTipConfirmButton(_ sender : UIButton) {

        guard self.viewModel.sePlayList.isEmpty == false else {
            showHUD(message: "您还未选择比赛")
            return }
       
        //胜分差特殊 只能单独计算
        if self.type == .胜分差 {
           
            TongJi.log(.场次确认, label: self.type.rawValue, att: .彩种)
            let story = UIStoryboard(storyboard: .Basketball)
            let vc = story.instantiateViewController(withIdentifier: "BasketballConfirmVC") as! CXMMBasketballConfirmVC
            vc.viewModel.sePlaySet = self.viewModel.sePlaySet
            vc.type = self.type
            vc.viewModel.deSePlayList = self.viewModel.sePlayList
            vc.viewModel.lotteryClassifyId = self.viewModel.lotteryClassifyId
            vc.viewModel.lotteryPlayClassifyId = self.viewModel.lotteryPlayClassifyId
            pushViewController(vc: vc)
        
        }else{
            guard self.viewModel.sePlayList.count >= 2 else {
                let play = self.viewModel.sePlayList[0]
                if play.playInfo.matchPlays.count == 1 {
                    guard play.playInfo.matchPlays[0].single == true else {
                        showHUD(message: "您还需要再选择一场比赛")
                        return }
                    
                    TongJi.log(.场次确认, label: self.type.rawValue, att: .彩种)
                    let story = UIStoryboard(storyboard: .Basketball)
                    let vc = story.instantiateViewController(withIdentifier: "BasketballConfirmVC") as! CXMMBasketballConfirmVC
                    vc.viewModel.sePlaySet = self.viewModel.sePlaySet
                    vc.type = self.type
                    vc.viewModel.deSePlayList = self.viewModel.sePlayList
                    vc.viewModel.lotteryClassifyId = self.viewModel.lotteryClassifyId
                    vc.viewModel.lotteryPlayClassifyId = self.viewModel.lotteryPlayClassifyId
                    pushViewController(vc: vc)
                    
                }else{
                    guard play.playInfo.matchPlays.count == 4 else { return }
                    
                    let can = isAllSingle(playList: viewModel.sePlayList[0])
                    
                    if can {
                        let story = UIStoryboard(storyboard: .Basketball)
                        let vc = story.instantiateViewController(withIdentifier: "BasketballConfirmVC") as! CXMMBasketballConfirmVC
                        vc.viewModel.sePlaySet = self.viewModel.sePlaySet
                        vc.type = self.type
                        vc.viewModel.deSePlayList = self.viewModel.sePlayList
                        vc.viewModel.lotteryClassifyId = self.viewModel.lotteryClassifyId
                        vc.viewModel.lotteryPlayClassifyId = self.viewModel.lotteryPlayClassifyId
                        pushViewController(vc: vc)
                    }else {
                        showHUD(message: "您还需要再选择一场比赛")
                    }
                }
                
                return
            }
            
            TongJi.log(.场次确认, label: self.type.rawValue, att: .彩种)
            let story = UIStoryboard(storyboard: .Basketball)
            let vc = story.instantiateViewController(withIdentifier: "BasketballConfirmVC") as! CXMMBasketballConfirmVC
            vc.viewModel.sePlaySet = self.viewModel.sePlaySet
            vc.type = self.type
            vc.viewModel.deSePlayList = self.viewModel.sePlayList
            vc.viewModel.lotteryClassifyId = self.viewModel.lotteryClassifyId
            vc.viewModel.lotteryPlayClassifyId = self.viewModel.lotteryPlayClassifyId
            pushViewController(vc: vc)
        }
    }
    
    @IBAction func didTipDeleteButton(_ sender : UIButton) {
        viewModel.removeAll()
    }
    
    
    func isAllSingle(playList: BBPlayModel) -> Bool {
        var allSin = true
        
        maxNum.removeAll()
        maxNum.insert(8)
        
        let spf = playList.shengfu
        let rangSpf = playList.rangfen
        let daxiaofen = playList.daxiaofen
        let shengFenCha = playList.shengFenCha
        
        
        
        
        if spf.homeCell.selected || spf.visiCell.selected {
            if spf.single == false {
                allSin = false
                //break
            }
        }
        
        if rangSpf.homeCell.selected || rangSpf.visiCell.selected {
            if rangSpf.single == false {
                allSin = false
                //break
            }
        }
        
        if daxiaofen.homeCell.selected || daxiaofen.visiCell.selected {
            if daxiaofen.single == false {
                allSin = false
                //break
            }
        }
        
        
        if shengFenCha != nil {
            var i = 0
            for cell in shengFenCha.visiSFC  {
                
                if cell.selected{
                    allSin = shengFenCha.visiSFC[i].selected
                    break
                }
                i += 1
            }
            
            var j = 0
            for cell in shengFenCha.homeSFC {
                
                if cell.selected{
                    allSin = shengFenCha.homeSFC[j].selected
                    break
                }
                j += 1
            }
            
            var s = 0
            for cell in playList.seCellList {
                
                if cell.playType != "3"{
                    allSin = false
                    break
                }
                s += 1
            }
        }
        
        
//        var scoreSin = false
//
//        var selected :Bool = false
//
//        var homeScore = true
//        var visiScore = true
//        var daxiaofenSin = true
//
//        if shengFenCha.homeCell.cellSons != nil {
//            for cell in shengFenCha.visitingCell.cellSons {
//                if cell.isSelected.asObserver().hasObservers{
//                    homeScore = shengFenCha.single
//                    selected = true
//                    maxNum.insert(4)
//                    break
//                }
//            }
//
//            for cell in shengFenCha.visitingCell.cellSons {
//                if cell.isSelected.asObserver().hasObservers {
//                    visiScore = shengFenCha.single
//                    selected = true
//                    maxNum.insert(4)
//                    break
//                }
//            }
//        }
//
//        if daxiaofen.matchCells != nil {
//            for cell in daxiaofen.matchCells {
//                if cell.isSelected.asObserver().hasObservers{
//                    daxiaofenSin = daxiaofen.single
//                    selected = true
//                    maxNum.insert(6)
//                    break
//                }
//            }
//        }
//
//
//        if homeScore == false ||  visiScore == false || daxiaofenSin == false {
//            allSin = false
//        }
//
//        if spf.homeCell != nil {
//            if spf.homeCell!.isSelected.asObserver().hasObservers || spf.visitingCell.isSelected.asObserver().hasObservers {
//                if spf.single == false {
//                    allSin = false
//                    //break
//                }
//            }
//        }
//
//        if rangSpf.homeCell != nil {
//            if rangSpf.homeCell!.isSelected.asObserver().hasObservers || rangSpf.visitingCell.isSelected.asObserver().hasObservers {
//                if rangSpf.single == false {
//                    allSin = false
//                    //break
//                }
//            }
//        }
        
        return allSin
    }
}

extension CXMMBasketballVC {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "pushConfirm":
//            let vc = segue.destination as! CXMMBasketballConfirmVC
//            vc.viewModel.sePlaySet = self.viewModel.sePlaySet
//            vc.type = self.type
//            vc.viewModel.deSePlayList = self.viewModel.sePlayList
//            vc.viewModel.lotteryClassifyId = self.viewModel.lotteryClassifyId
//            vc.viewModel.lotteryPlayClassifyId = self.viewModel.lotteryPlayClassifyId
//        default: break
//
//        }
//    }
}

// MARK: - header 点击事件
extension CXMMBasketballVC: BasketBallHotSectionHeaderDelegate,
                            BasketBallSectionHeaderDelegate {
    
    func spreadHot(sender: UIButton, section: Int) {
        let header = matchModel.list[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func spread(sender: UIButton, section: Int) {
        let header = matchModel.list[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}


// MARK: - 混合 按钮 点击   delegate
//extension CXMMBasketballVC  {
//    func didSelectedHunHeView(view: BasketBallHunheView, teamInfo: BasketballListModel, index: IndexPath) {
//        guard self.matchModel.list.isEmpty == false else { return }
//        let cell = self.tableView.cellForRow(at: index) as! BasketballHunheCell
//        let matchModel = self.matchModel.list[index.section]
//        cell.playInfo = matchModel.playList[index.row]
//
//        //self.tableView.reloadRows(at: [index], with: .none)
//        guard viewModel.sePlayList.count < MaxSelectedNum else {
//
//            var change = true
//
//            for team in viewModel.sePlayList {
////                let playInfo = team.playInfo!
////                if cell.playInfo == teamInfo {
////                    change = false
////                    break
////                }
//            }
//            if change {
//                view.backSelectedState()
//                showHUD(message: "最多可选15场比赛")
//                self.tableView.reloadRows(at: [index], with: .none)
//            }
//
//            return }
//        viewModel.sePlaySet.insert(cell.viewModel)
//    }
//
//    func didDeSelectedHunHeView(view: BasketBallHunheView, teamInfo: BasketballListModel, index: IndexPath) {
//        //self.tableView.reloadRows(at: [index], with: .none)
//
//        let cell = self.tableView.cellForRow(at: index) as! BasketballHunheCell
//        let matchModel = self.matchModel.list[index.section]
//        cell.playInfo = matchModel.playList[index.row]
//
//        guard viewModel.sePlayList.count == 0 else { return }
//        viewModel.sePlaySet.remove(cell.viewModel)
//    }
//
//}


// MARK: - 混合Cell Delegate
extension CXMMBasketballVC : BasketballHunheCellDelegate {
    // 点击 更多玩法
    func didTipMore(playInfo: BasketballListModel, viewModel : BBPlayModel) {
        let story = UIStoryboard(storyboard: .Basketball)
        
        let hunhePlay = story.instantiateViewController(withIdentifier: "BasketballHunhePlayPop") as! CXMMBasketballHunhePlayPop
        hunhePlay.configure(with: playInfo)
        
        hunhePlay.configure(with: viewModel)
        present(hunhePlay)
    }
}
// MARK: - 胜分差Cell Delegate
extension CXMMBasketballVC : BasketballShengfuChaCellDelegate,BasketballSFCPlayPopSelectCellListDelegate{
    func didTipShengfenCha(playInfo: BasketballListModel, viewModel : BBPlayModel) {
        let story = UIStoryboard(storyboard: .Basketball)
        
        let shengFenPlay = story.instantiateViewController(withIdentifier: "BasketballSFCPlayPop") as! CXMMBasketballSFCPlayPop
        shengFenPlay.selectCellListDelegate = self
        shengFenPlay.configure(with: playInfo)
        shengFenPlay.configure(with: viewModel)
        present(shengFenPlay)
    }
    func didSelectCellList(){
        self.tableView.reloadData()
    }
}

// MARK: - tableview delegate
extension CXMMBasketballVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - tableview DataSource
extension CXMMBasketballVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchModel != nil ? matchModel.list.count : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard matchModel.list[section].playList.isEmpty == false else { return 0 }
        let model = matchModel.list[section]
        
        switch model.isSpreading {
        case true:
            return matchModel.list[section].playList.count
        case false:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .混合投注:
            return initHunheCell(indexPath: indexPath)
        case .胜负:
            return initShengfuCell(indexPath: indexPath)
        case .让分胜负:
            return initRangFenCell(indexPath: indexPath)
        case .大小分:
            return initDaXiaoFenCell(indexPath: indexPath)
        case .胜分差:
            return initShengFenChaCell(indexPath: indexPath)
        }
    }
    
    // MARK: - Cell
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballHunheCell", for: indexPath) as! BasketballHunheCell
        cell.delegate = self
//        cell.teamView.delegate = self
//        cell.rangTeamView.delegate = self
//        cell.daXiaoTeamView.delegate = self
        let model = matchModel.list[indexPath.section].playList[indexPath.row]
        cell.configure(with: model)
        
        cell.configure(with: playViewModel.list[indexPath.section].list[indexPath.row], viewModel : viewModel)
        
        return cell
    }
    // 胜负
    private func initShengfuCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballShengfuCell", for: indexPath) as! BasketballShengfuCell
        
        let model = matchModel.list[indexPath.section].playList[indexPath.row]
        cell.configure(with: model)
        cell.configure(with: playViewModel.list[indexPath.section].list[indexPath.row])
        return cell
    }
    // 让分胜负
    private func initRangFenCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballRangCell", for: indexPath) as! BasketballRangCell
    
        let model = matchModel.list[indexPath.section].playList[indexPath.row]
        cell.configure(with: model)
        cell.configure(with: playViewModel.list[indexPath.section].list[indexPath.row])
        return cell
    }
    // 大小分
    private func initDaXiaoFenCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballDaxiaofenCell", for: indexPath) as! BasketballDaxiaofenCell
        let model = matchModel.list[indexPath.section].playList[indexPath.row]
        cell.configure(with: model)
        cell.configure(with: playViewModel.list[indexPath.section].list[indexPath.row])
        return cell
    }
    // 胜分差
    private func initShengFenChaCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballShengfuChaCell", for: indexPath) as! BasketballShengfuChaCell
        cell.delegate = self
        let model = matchModel.list[indexPath.section].playList[indexPath.row]
        cell.configure(with: model)
        cell.configure(with: playViewModel.list[indexPath.section].list[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0, hasHot {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BasketBallHotSectionHeader.identifier) as! BasketBallHotSectionHeader
            header.tag = section
            header.delegate = self
            header.configure(with: matchModel.list[section])
            return header
        }else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BasketBallSectionHeader.identifier) as! BasketBallSectionHeader
            header.tag = section
            header.delegate = self
            header.configure(with: matchModel.list[section])
            return header
        }
    }
}

extension CXMMBasketballVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch type {
        case .混合投注:
            return 220
        case .胜负:
            return 130
        case .让分胜负:
            return 130
        case .大小分:
            return 130
        case .胜分差:
            return UITableView.automaticDimension
        
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
// MARK: - title view
extension CXMMBasketballVC : CXMMBasketballMenuDelegate{
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        titleView.titleLabel?.font = Font17
        titleView.setTitle(type.rawValue, for: .normal)
        titleView.setTitleColor(ColorNavItem, for: .normal)
        
        titleView.addTarget(self, action: #selector(titleViewClicked(_:)), for: .touchUpInside)
        
        self.navigationItem.titleView = titleView
        titleIcon = UIImageView(image: UIImage(named: "Down"))
        
        titleView.addSubview(titleIcon)
        
        titleIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.right.equalTo(14)
            make.centerY.equalTo(titleView.snp.centerY)
        }
    }
    
    @objc private func titleViewClicked(_ sender: UIButton) {
        showMatchMenu()
        titleIcon.image = UIImage(named: "Upon")
    }
    
    private func showMatchMenu() {
        menu.configure(with: type)
        menu.show()
    }
    
    func didTipMenu(view: CXMMBasketballMenu, type: BasketballPlayType) {
        titleIcon.image = UIImage(named: "Down")
        
        // TODO: "处理，选择menu 项的逻辑"
        matchModel = nil
        self.playViewModel.list.removeAll()
        self.viewModel.removeAllSePlay()
        self.tableView.reloadData()
        
        self.type = type
        
        loadNewData()
    }
    
    func didCancel() {
        titleIcon.image = UIImage(named: "Down")
    }
}
