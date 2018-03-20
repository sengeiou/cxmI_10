//
//  BasePopViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasePopViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
        self.view.backgroundColor = UIColor(white: 0.3, alpha: 0.2)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
