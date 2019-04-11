//
//  NewsDetailFooter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol NewsDetailFooterDelegate {
    func didTipLookMore() -> Void
}

class NewsDetailFooter: UIView {

    public var delegate : NewsDetailFooterDelegate!
    
    private var lookMore: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        initSubview()
    }
    
    @objc private func lookMoreClicked(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipLookMore()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lookMore.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
        }
    }
    private func initSubview() {
        lookMore = UIButton(type: .custom)
        lookMore.setTitle("查看更多", for: .normal)
        lookMore.setTitleColor(Color9F9F9F, for: .normal)
        lookMore.addTarget(self, action: #selector(lookMoreClicked(_:)), for: .touchUpInside)
        
        self.addSubview(lookMore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
