//
//  PasswordAlertView.swift
//  SwiftPassword
//
//  Created by 王涛 on 2017/7/24.
//  Copyright © 2017年 王涛. All rights reserved.
//



import UIKit

protocol PasswordAlertViewDelegate:NSObjectProtocol{
    func passwordCompleteInAlertView(alertView:PasswordAlertView, password:NSString)
}

class PasswordAlertView: UIView,UITextFieldDelegate {

    let ScreenH = UIScreen.main.bounds.size.height
    let ScreenW = UIScreen.main.bounds.size.width
    let buttonH = 49
    let borderH = 45
    let pointSize = CGSize.init(width: 10, height: 10)
    let pointCount = 6
    var pointViewArray = NSMutableArray.init()
    var BGView = UIView.init()
    var textFiled = UITextField()
    
    weak var delegate:PasswordAlertViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    func setupUI() {
        //背景颜色
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //弹框背景
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - 30, height: 200))
        bgView.center = self.center;
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = true
        BGView = bgView
        let bgViewW = bgView.frame.size.width
        let bgViewH = bgView.frame.size.height
        
        //tipsLabel
        let tipLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: bgViewW, height: 40))
        tipLabel.text = "请输入您的密码";
        tipLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(tipLabel)
        //line
        let line = UIView.init(frame: CGRect.init(x: 0, y: tipLabel.frame.size.height + 1, width: bgViewW, height: 1))
        line.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        bgView.addSubview(line)
        
        //密码框
        for i in 0..<pointCount {
            let pswLabel = UILabel.init(frame: CGRect.init(x: (Int(bgViewW) - Int(borderH*pointCount))/2 + borderH * i, y: Int(line.frame.origin.y + 30), width: borderH, height: borderH))
            pswLabel.layer.borderWidth = 1
            pswLabel.layer.borderColor = UIColor.gray.cgColor
            let pointView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: pointSize.width, height: pointSize.height))
            pointView.center = pswLabel.center;
            pointView.backgroundColor = UIColor.black
            pointView.layer.cornerRadius = pointSize.width/2
            pointView.layer.masksToBounds = true
            pointView.isHidden = true;
            bgView.addSubview(pointView)
            pointViewArray.add(pointView)
            bgView.addSubview(pswLabel)
        }
        
        let textFiled = UITextField.init(frame: CGRect.init(x: 0, y: Int(line.frame.origin.y) + 30, width: Int(bgViewW), height: borderH))
        textFiled.backgroundColor = UIColor.clear
        //设置代理
        textFiled.delegate = self
        //监听编辑状态的变化
        textFiled.addTarget(self, action: #selector(textFiledValueChanged(textFiled:)), for: .editingChanged)
        textFiled.tintColor = UIColor.clear
        textFiled.textColor = UIColor.clear
        textFiled.becomeFirstResponder()
        //设置键盘类型为数字键盘
        textFiled.keyboardType = .numberPad
        self.textFiled = textFiled;
        bgView.addSubview(self.textFiled)
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(Info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(Info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let line2 = UIView.init(frame: CGRect.init(x: 0, y: Int(bgViewH) - buttonH - 1, width: Int(bgViewW), height: 1))
        line2.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        bgView.addSubview(line2)
        //取消按钮
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.frame = CGRect.init(x: 0, y: Int(bgViewH) - buttonH, width: Int(bgViewW/2), height: buttonH)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        cancelButton.addTarget(self, action:#selector(cancel(sender:)), for: .touchUpInside)
        bgView.addSubview(cancelButton)
        //确认按钮
        let sureButton = UIButton.init(type: .custom)
        sureButton.frame = CGRect.init(x: Int(bgViewW/2), y: Int(bgViewH) - buttonH, width: Int(bgViewW/2), height: buttonH)
        sureButton.setTitle("确认", for: .normal)
        sureButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        sureButton.addTarget(self, action:#selector(sure(sender:)), for: .touchUpInside)
        bgView.addSubview(sureButton)
        //竖分割线
        let verticalLine = UIView.init(frame: CGRect.init(x: Int(bgViewW/2), y: Int(bgViewH) - buttonH + 10, width: 1, height: buttonH - 20))
        verticalLine.backgroundColor = UIColor.lightGray
        bgView.addSubview(verticalLine)
        
        self.addSubview(bgView)
    }
    
    func cancel(sender:UIButton) {
        
        self.removeFromSuperview()
    }
    
    func sure(sender:UIButton) {
        
        print("确定")
        delegate?.passwordCompleteInAlertView(alertView:self, password: self.textFiled.text! as NSString)
    }
    
    func textFiledValueChanged(textFiled:UITextField) {
        
        for pointView  in self.pointViewArray {
            (pointView as! UIView).isHidden = true
        }
        
        for i in 0..<Int((textFiled.text?.characters.count)!) {
            (self.pointViewArray.object(at: i) as! UIView).isHidden = false
        }
        
        if textFiled.text?.characters.count == pointCount {
            print("输入完成")
        }
        
    }
    
    func keyBoardWillShow(Info:NSNotification) {
        
        let userInfos = Info.userInfo![UIKeyboardFrameEndUserInfoKey]
        let heigh = ((userInfos as AnyObject).cgRectValue.size.height)
        self.BGView.center = CGPoint.init(x: self.BGView.center.x , y:ScreenH - heigh - self.BGView.frame.size.height/2 - 10)
    }
    
    func keyBoardWillHide(Info:NSNotification) {
        self.BGView.center = self.center
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {//判断是是否为删除键
            return true
        }else if (textField.text?.characters.count)! >= pointCount {
            //当输入的密码大于等于6位后就忽略
            return false
        } else {
            return true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
