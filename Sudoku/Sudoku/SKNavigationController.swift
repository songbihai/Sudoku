//
//  SKNavigationController.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/27.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

class SKNavigationController: UINavigationController {

    fileprivate var backPanGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let target = interactivePopGestureRecognizer?.delegate
        if let t = target {
            backPanGesture = UIPanGestureRecognizer(target: t, action: Selector(("handleNavigationTransition:")))
            backPanGesture?.delegate = self
            view.addGestureRecognizer(backPanGesture!)
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension SKNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: pan.view)
            return (childViewControllers.count > 1) && (velocity.x > 0) && (velocity.y < 300)
        }else {
            return true
        }
    }
}
