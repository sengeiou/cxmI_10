//
//  CXMMBasketballOrderPro.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMBasketballOrderScheme: BaseViewController {

    public var orderSn : String!
    public var programmeSn : String!
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var programme: UILabel!
    
    private var schemeInfo : OrderSchemeInfoModel!
    
    private var viewModel : BBSchemeViewModel = BBSchemeViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "方案"
//        setData()
        initSubview()
        loadNewData()
    }

    private func setData() {
        viewModel.programme.asObserver()
        .bind(to: programme.rx.attributedText)
        .disposed(by: disposeBag)
    }
    
    private func initSubview() {
        
    }
    
}

extension CXMMBasketballOrderScheme : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMBasketballOrderScheme : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count != 0 ? viewModel.list.count : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBSchemeCell", for: indexPath) as! BBSchemeCell
       
        if viewModel.list.count != 0 {
            let model = viewModel.list[indexPath.row]
            
            model.betInfo.asObserver()
                .bind(to: cell.betInfo.rx.text)
                .disposed(by: disposeBag)
            
            model.mulitle.asObserver()
                .bind(to: cell.mulitle.rx.text)
                .disposed(by: disposeBag)
            
            model.passType.asObserver()
                .bind(to: cell.passType.rx.text)
                .disposed(by: disposeBag)
            
            model.state.asObserver()
                .bind(to: cell.state.rx.text)
                .disposed(by: disposeBag)
        }
        
        return cell
    }
}
extension CXMMBasketballOrderScheme {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - 网络请求
extension CXMMBasketballOrderScheme {
    private func loadNewData() {
        schemeRequest()
    }
    private func schemeRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = basketBallProvider.rx.request(.orderScheme(orderSn: orderSn, programmeSn: programmeSn))
            .asObservable()
            .mapObject(type: OrderSchemeInfoModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.schemeInfo = data
                
                weakSelf?.viewModel.setData(data: data, programmeSn: (weakSelf?.programmeSn)!)
                
                weakSelf?.setData()
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
