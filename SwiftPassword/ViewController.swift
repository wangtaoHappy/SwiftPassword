//
//  ViewController.swift
//  SwiftPassword
//
//  Created by 王涛 on 2017/7/24.
//  Copyright © 2017年 王涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PasswordAlertViewDelegate {

    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button .addTarget(self, action: #selector(inputPassword), for: .touchUpInside)
        button.setTitle("点我输入密码", for: .normal)
        button.backgroundColor = UIColor.red
        button.frame = CGRect.init(x: 60, y: 140, width: 180, height: 40)
        self.view.addSubview(button)
        
        label.frame = CGRect.init(x: 60, y: 200, width: 120, height: 40)
        self.view.addSubview(label)
        
    }

    func inputPassword() {
        let pswAlertView = PasswordAlertView.init(frame: self.view.bounds)
        pswAlertView.delegate = self
        self.view.addSubview(pswAlertView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func passwordCompleteInAlertView(alertView: PasswordAlertView, password: NSString) {
        alertView.removeFromSuperview()
        print("password:",password);
        self.label.text = NSString.init(format: "密码:\(password)" as NSString) as String
    }

}

