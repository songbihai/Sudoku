//
//  SKSurePopupView.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/26.
//  Copyright © 2017年 songbihai. All rights reserved.
//  瞎写的

import UIKit

class SKSurePopupView: UIControl {

    var nameTextField: UITextField?
    
    private var cancelBtn: UIButton!
    private var sureBtn: UIButton!
    private var titleLabel: UILabel?
    private var contentView: UIView!
    private var left: (() -> ())?
    private var right: (() -> ())?
    
    class func show(title: String?, detailText: String?, leftText: String, rightText: String, animated: Bool) -> SKSurePopupView {
        let surePopupView = SKSurePopupView.init(title: title, detailText: detailText, leftText: leftText, rightText: rightText, animated: animated)
        surePopupView.showOnLastWindow(animated: animated)
        return surePopupView
    }
    
    func leftRightAction(left: @escaping () -> (), right: @escaping () -> ()) {
        self.left = left
        self.right = right
    }
    
    func hid(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.15, animations: {
                self.alpha = 0.0
                self.contentView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }, completion: { (finished) in
                    self.removeFromSuperview()
            })
        }else {
            self.removeFromSuperview()
        }
    }
    
    
    private func showOnLastWindow(animated: Bool) {
        //last window的hidden会为YES
        if let w = UIApplication.shared.windows.last {
            print(w, UIApplication.shared.windows)
        }
        if let v = UIApplication.shared.keyWindow {
            frame = v.bounds
            v.addSubview(self)
            if animated {
                alpha = 0.0
                contentView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                UIView.animate(withDuration: 0.15, animations: { 
                    self.alpha = 1.0
                    self.contentView.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    
    private var title: String?
    private var detailText: String?
    private var leftText: String!
    private var rightText: String!
    private var animated: Bool = true
    
    
    init(title: String?, detailText: String?, leftText: String, rightText: String, animated: Bool) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.detailText = detailText
        self.leftText = leftText
        self.rightText = rightText
        self.animated = animated
        addAllSubviews()
        backgroundColor = UIColor(hex: 0x000000).withAlphaComponent(0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
        backgroundColor = UIColor(hex: 0x000000).withAlphaComponent(0.5)
    }
    
    private func addAllSubviews() {
        contentView = UIView()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        contentView.snp.makeConstraints { [unowned self](make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-35)
            make.width.equalTo(270)
        }
        
        if let t = title, t.count > 0 {
            titleLabel = UILabel()
            titleLabel?.textColor = UIColor(hex: 0x333333)
            titleLabel?.font = UIFont.systemFont(ofSize: 16)
            contentView.addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints { [unowned self](make) in
                make.centerY.equalTo(self.contentView.snp.top).offset(35)
                make.centerX.equalTo(self.contentView)
            }
        }
        
        if let d = detailText, d.count > 0 {
            nameTextField = UITextField()
            nameTextField?.textAlignment = .center
            nameTextField?.borderStyle = .roundedRect
            nameTextField?.textColor = UIColor(hex: 0x333333)
            nameTextField?.font = UIFont.systemFont(ofSize: 14)
            contentView.addSubview(nameTextField!)
            nameTextField?.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(40)
                make.right.equalTo(self.contentView).offset(-40)
                make.height.equalTo(40)
            })
            if let tl = titleLabel {
                nameTextField?.snp.makeConstraints({ (make) in
                    make.top.equalTo(tl.snp.bottom).offset(12)
                })
            }else {
                nameTextField?.snp.makeConstraints({ [unowned self](make) in
                    make.centerY.equalTo(self.contentView).offset(-50)
                })
            }
        }
        
        if nameTextField != nil {
            titleLabel?.snp.remakeConstraints { [unowned self](make) in
                make.top.equalTo(self.contentView).offset(12)
                make.centerX.equalTo(self.contentView)
            }
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: 0xF2F2F2)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            if nameTextField != nil {
                make.top.equalTo(nameTextField!.snp.bottom).offset(13)
            }else {
                make.top.equalTo(self.contentView).offset(70)
            }
            
            make.left.right.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        cancelBtn = UIButton()
        cancelBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(49)
            make.left.bottom.equalTo(self.contentView)
        }
        
        sureBtn = UIButton()
        sureBtn.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.backgroundColor = UIColor(hex: 0x00C6FF)
        contentView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { [unowned self](make) in
            make.top.bottom.width.equalTo(self.cancelBtn)
            make.left.equalTo(self.cancelBtn.snp.right)
            make.right.equalTo(self.contentView)
        }
        titleLabel?.text = title
        nameTextField?.placeholder = detailText
        if leftText != nil && leftText.count > 0 {
            cancelBtn.setTitle(leftText, for: .normal)
        }else {
            cancelBtn.setTitle("取消", for: .normal)
        }
        
        if rightText != nil && rightText.count > 0 {
            sureBtn.setTitle(rightText, for: .normal)
        }else {
            sureBtn.setTitle("确定", for: .normal)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nameTextField?.resignFirstResponder()
    }
    
    @objc private func rightClick() {
        hid(animated: true)
        right?()
    }
    
    @objc private func leftClick() {
        hid(animated: true)
        left?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
