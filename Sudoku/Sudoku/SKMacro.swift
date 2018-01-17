//
//  SKMacro.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/26.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

let SK_SCREEN_WIDTH: CGFloat = {
    return UIScreen.main.bounds.width
}()

let SK_SCREEN_HEIGHT: CGFloat = {
    return UIScreen.main.bounds.height
}()

let SK_TINTCOLOR: UIColor = {
    return UIColor.rgba(r: 39, g: 43, b: 45)
}()

let IS_PHONE: Bool = {
    return UIDevice.current.userInterfaceIdiom == .phone
}()

let IS_PAD: Bool = {
    return UIDevice.current.userInterfaceIdiom == .pad
}()

let IS_PHONEX: Bool = {
    return UIScreen.main.bounds.height == 812
}()


let SK_NAVIGATIONBAR_HEIGHT: CGFloat = 44

let SK_NAVIGATION_HEIGHT: CGFloat = 64

let SK_BOLDLINES_COLOR: UIColor = UIColor.black

let SK_THINLINE_COLOR: UIColor = UIColor.darkGray

let SK_EASY_TIMES: String = "SK_EASY_TIMES"

let SK_MID_TIMES: String = "SK_MID_TIMES"

let SK_HARD_TIMES: String = "SK_HARD_TIMES"



extension UIColor {
    
    convenience init(hex: UInt) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue:  CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: CGFloat(1))
    }
    
    class func rgba(r: Int, g: Int, b: Int, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
}


private class Block<T> {
    let f : T
    init (_ f: T) { self.f = f }
}

extension Timer {
    static func sb_scheduledTimerWithTimeInterval(ti: TimeInterval, block: ()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: ti, target:
            self, selector: #selector(Timer.sb_blcokInvoke(timer:)), userInfo: Block(block), repeats: repeats)
    }
    
    @objc static func sb_blcokInvoke(timer: Timer) {
        if let block = timer.userInfo as? Block<()->()> {
            block.f()
        }
    }
}
