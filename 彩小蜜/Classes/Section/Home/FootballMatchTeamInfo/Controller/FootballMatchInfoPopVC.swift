//
//  FootballMatchInfoPopVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballMatchInfoPopVCDelegate {
    func didTipPopConfirm(matchId : String) -> Void
}

class FootballMatchInfoPopVC: BasePopViewController, BottomViewDelegate {
    
    

    public var matchId : String! {
        didSet{
            matchInfoRequest()
        }
    }
    public var delegate : FootballMatchInfoPopVCDelegate!
    // MARK: 属性 private
    private var teamInfo : FootballMatchInfoModel! {
        didSet{
            header.matchInfo = teamInfo.matchInfo
            ratioView.supportInfo = teamInfo.hadTeamSupport
            rangRatioView.supportInfo = teamInfo.hhadTeamSupport
            setUpViewInfo()
        }
    }
    
    private var header : FootballTeamHeader!
    private var matchDetail : UILabel! // 近期状态
    private var homeDetail : UILabel!  // 主队主场
    private var visiDetail : UILabel!  // 客队客场
    private var sportDetail: UILabel!  // 相对交锋
    private var buyDetail : FootballHunheView! // 投注比例
    private var bottomView : BottomView!
    
    private var ratioView: FootballBuyRatioView!
    private var ratioTitle : UILabel!
    private var rangRatioView: FootballBuyRatioView!
    private var rangRatioTitle : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }
    
    func didTipConfitm() {
        dismiss(animated: true , completion: nil )
        guard delegate != nil else { return }
        delegate.didTipPopConfirm(matchId : matchId)
    }
    
    func didTipCancel() {
        dismiss(animated: true , completion: nil )
    }
    
    private func setUpViewInfo() {
        let hhInfo = teamInfo.hhMatchTeamInfo!
        let vvInfo = teamInfo.vvMatchTeamInfo!
        let hvInfo = teamInfo.hvMatchTeamInfo!
        matchDetail.text = "主队\(hhInfo.win!)胜\(hhInfo.draw!)平\(hhInfo.lose!)负 客队\(vvInfo.win!)胜\(vvInfo.draw!)平\(vvInfo.lose!)负"
        homeDetail.text = "主队\(hhInfo.win!)胜\(hhInfo.draw!)平\(hhInfo.lose!)负"
        visiDetail.text = "客队\(vvInfo.win!)胜\(vvInfo.draw!)平\(vvInfo.lose!)负"
        
        let muAtt = NSMutableAttributedString(string: "共\(hvInfo.total!)次交锋 主队 ")
        let homeAtt = NSAttributedString(string: "\(hvInfo.win!)胜", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
        let flatAtt = NSAttributedString(string: "\(hvInfo.draw!)平", attributes: [NSAttributedStringKey.foregroundColor: Color0099D9])
        let visiAtt = NSAttributedString(string: "\(hvInfo.lose!)负", attributes: [NSAttributedStringKey.foregroundColor: Color44AE35])
        muAtt.append(homeAtt)
        muAtt.append(flatAtt)
        muAtt.append(visiAtt)
        
        sportDetail.attributedText = muAtt
        
        guard teamInfo.hhadTeamSupport != nil , teamInfo.hhadTeamSupport.fixedOdds != nil else { return }
        if teamInfo.hhadTeamSupport.fixedOdds < 0 {
            rangRatioTitle.text = "\(teamInfo.hhadTeamSupport.fixedOdds!)"
        }else {
            rangRatioTitle.text = "+\(teamInfo.hhadTeamSupport.fixedOdds!)"
        }
        
    }
    
    // MARK: - 网络请求
    private func matchInfoRequest() {
        weak var weakSelf = self
        guard matchId != nil else { return }
        _ = homeProvider.rx.request(.matchTeamInfoSum(matchId: matchId))
            .asObservable()
            .mapObject(type: FootballMatchInfoModel.self )
            .subscribe(onNext: { (data) in
                weakSelf?.teamInfo = data
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func initSubview() {
        self.viewHeight = 440 * defaultScale + SafeAreaBottomHeight
        
        let line = getLine()
        let lineOne = getLine()
        let lineTwo = getLine()
        let lineThree = UIView()
        lineThree.backgroundColor = ColorC8C8C8
        
        header = FootballTeamHeader()
        header.headerStyle = .默认
        
        let matchState = getLabel()
        matchState.text = "近期状态"
        matchState.sizeToFit()
        let homeTitle = getLabel()
        homeTitle.textColor = Color9F9F9F
        homeTitle.text = "主队主场"
        let visiTitle = getLabel()
        visiTitle.textColor = Color9F9F9F
        visiTitle.text = "客队客场"
        let sportsTitle = getLabel()
        sportsTitle.textColor = Color9F9F9F
        sportsTitle.text = "相对交锋"
        let buyTitle = getLabel()
        buyTitle.textColor = Color9F9F9F
        buyTitle.text = "投注比例"
        
        matchDetail = getLabel()
        matchDetail.text = "主队5胜4平1负"
        homeDetail = getLabel()
        homeDetail.text = "主队5胜4平1负"
        visiDetail = getLabel()
        visiDetail.text = "客队5胜4平1负"
        sportDetail = getLabel()
        sportDetail.text = "共10次交锋 主队1胜5平4负"
        //buyDetail = getLabel()
        
        bottomView = BottomView()
        bottomView.confirmTitle = "查看详情"
        bottomView.delegate = self
        
        ratioTitle = getLabel()
        ratioTitle.text = "0"
        ratioTitle.textAlignment = .center
        ratioTitle.backgroundColor = ColorC7C7C7
        ratioView = FootballBuyRatioView()
        
        rangRatioTitle = getLabel()
        rangRatioTitle.text = "-1"
        rangRatioTitle.textAlignment = .center
        rangRatioTitle.backgroundColor = ColorF6AD41
        rangRatioView = FootballBuyRatioView()
        
        
        self.pushBgView.addSubview(header)
        self.pushBgView.addSubview(line)
        self.pushBgView.addSubview(lineOne)
        self.pushBgView.addSubview(lineTwo)
        self.pushBgView.addSubview(lineThree)
        self.pushBgView.addSubview(matchState)
        self.pushBgView.addSubview(homeTitle)
        self.pushBgView.addSubview(visiTitle)
        self.pushBgView.addSubview(sportsTitle)
        self.pushBgView.addSubview(buyTitle)
        self.pushBgView.addSubview(matchDetail)
        self.pushBgView.addSubview(homeDetail)
        self.pushBgView.addSubview(visiDetail)
        self.pushBgView.addSubview(sportDetail)
        //self.pushBgView.addSubview(buyDetail)
        self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(ratioTitle)
        self.pushBgView.addSubview(rangRatioTitle)
        self.pushBgView.addSubview(rangRatioView)
        self.pushBgView.addSubview(ratioView)
        
        
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(140 * defaultScale)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).offset(44 * defaultScale)
            make.height.equalTo(1)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
        }
        lineOne.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(44 * defaultScale)
            make.height.left.right.equalTo(line )
        }
        lineTwo.snp.makeConstraints { (make) in
            make.top.equalTo(lineOne.snp.bottom).offset(44 * defaultScale)
            make.height.left.right.equalTo(line)
        }
        lineThree.snp.makeConstraints { (make) in
            make.top.equalTo(lineTwo.snp.bottom).offset(44 * defaultScale)
            make.height.left.right.equalTo(line)
        }
        
        matchState.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.equalTo(16 * defaultScale)
            make.bottom.equalTo(line.snp.top)
            make.width.equalTo(70)
        }
        matchDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchState)
            make.left.equalTo(matchState.snp.right).offset(29 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
        }
        homeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(lineOne.snp.top)
            make.left.width.equalTo(matchState)
        }
        homeDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeTitle)
            make.left.equalTo(homeTitle.snp.right).offset(29 * defaultScale)
            make.right.equalTo(matchDetail)
        }
        visiTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lineOne.snp.bottom)
            make.bottom.equalTo(lineTwo.snp.top)
            make.left.width.equalTo(matchState)
        }
        visiDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(visiTitle)
            make.left.equalTo(visiTitle.snp.right).offset( 29 * defaultScale)
            make.right.equalTo(matchDetail)
        }
        sportsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lineTwo.snp.bottom)
            make.bottom.equalTo(lineThree.snp.top)
            make.left.width.equalTo(matchState)
        }
        sportDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(sportsTitle)
            make.left.equalTo(sportsTitle.snp.right).offset( 29 * defaultScale)
            make.right.equalTo(matchDetail)
        }
        buyTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lineThree.snp.bottom)
            make.height.equalTo(homeTitle)
            make.left.width.equalTo(matchState)
        }
        
        ratioTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lineThree.snp.bottom).offset(8 * defaultScale)
            make.height.equalTo(36 * defaultScale)
            make.left.equalTo(buyTitle.snp.right).offset(29 * defaultScale)
            make.width.equalTo(20 * defaultScale)
        }
        rangRatioTitle.snp.makeConstraints { (make) in
            make.top.equalTo(ratioTitle.snp.bottom).offset(-1)
            make.left.height.width.equalTo(ratioTitle)
        }
        ratioView.snp.makeConstraints { (make) in
            make.top.equalTo(ratioTitle)
            make.left.equalTo(ratioTitle.snp.right)
            make.right.equalTo(-16 * defaultScale)
            make.height.equalTo(ratioTitle)
        }
        rangRatioView.snp.makeConstraints { (make ) in
            make.top.equalTo(ratioView.snp.bottom).offset(-1)
            make.left.height.right.equalTo(ratioView)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(36 * defaultScale)
        }
    }
    
    private func getLine() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "line")
        return view
    }
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color505050
        lab.textAlignment = .left
        
        
        return lab
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
