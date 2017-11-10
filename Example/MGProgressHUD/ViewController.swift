//
//  ViewController.swift
//  UseWKWebKit
//
//  Created by Winann on 16/6/28.
//  Copyright © 2016年 Winann. All rights reserved.
//

import UIKit
import MGProgressHUD

class ViewController: UIViewController {

    // MARK: - property
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        }
    }
    
    fileprivate var dataSource:[String] = ["showTextAndHiddenView",
                                           "showSuccessAndHiddenView",
                                           "showErrorAndHiddenView",
                                           "showView",
                                           "hiddenAll",
                                           "showDelayText",
                                           "showLoading",
                                           "showFillLoading"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var images = [UIImage]()
//        for i in 1...36 {
//            images.append(UIImage(named: "loading\(i)")!)
//        }
//
//        MGProgressConfiguration.shared.config { () -> [UIImage]? in
//            return images
//        }
        
//        print(MGProgressConfiguration.shared.images()?.count)
        
        
//        print("UIImage:\(UIImage(named:"error.png"))")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        MGProgressHUD.hiddenAllhubToView(view, animated: true)
    }
    
}

extension ViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            MGProgressHUD.showTextAndHiddenView("测试啊")
        case 1:
            MGProgressHUD.showSuccessAndHiddenView("成功")
        case 2:
            MGProgressHUD.showErrorAndHiddenView("失败")
        case 3:
            MGProgressHUD.showView(view, iconImage: UIImage(named: "111"), message: "页面载入失败咯", detailText: "")
        case 4:
            MGProgressHUD.hiddenAllhubToView(view, animated: true)
        case 5:
            MGProgressHUD.showTextAndHiddenView("延迟了3s 消失", afterDelay: 3)
        case 6:
            MGProgressHUD.showLoadingView(self.view, message: "加载中")
        case 7:
            MGProgressHUD.showLoadingFillView(self.view, message: "加载中")
        default:
            return
        }
    }
}
