//
//  ViewController.swift
//  UseWKWebKit
//
//  Created by Winann on 16/6/28.
//  Copyright © 2016年 Winann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showTexAndHidden(sender: UIButton) {
        MGProgressHUD.showTextAndHiddenView("测试啊")
    }

    @IBAction func success(sender: AnyObject) {
        MGProgressHUD.showSuccessAndHiddenView("成功")
    }
    
    @IBAction func failed(sender: UIButton) {
        MGProgressHUD.showErrorAndHiddenView("失败")
    }
    
}

