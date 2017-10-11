//
//  SKBaseViewController.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/24.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit
import SnapKit

class SKBaseViewController: UIViewController {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "标准数独"
        return label
    }()
    
    var navigationView: UIView = {
        let navigation = UIView()
        navigation.backgroundColor = SK_TINTCOLOR
        return navigation
    }()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        view.addSubview(navigationView)
        
        view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        
        navigationView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            if IS_PHONEX {
                make.height.equalTo(SK_NAVIGATION_HEIGHT + 22)
            }else {
                make.height.equalTo(SK_NAVIGATION_HEIGHT)
            }
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(navigationView).offset(IS_PHONEX ? 22 : 10)
            make.centerX.equalTo(navigationView)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
