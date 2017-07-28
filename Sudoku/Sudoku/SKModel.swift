//
//  SKModel.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/24.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

enum SKState: Int {
    case selected
    case associated
    case error
    case normal
}

struct SKModel {
    
    // 状态
    var state: SKState = .normal
    
    // 位置
    var point: (Int, Int)
    
    // 是否挖空
    var isBlank: Bool = false
    
    // 原始值
    var value: Int = 0
    
    // 在生成数独的时候用来装可以填的值
    lazy var validList: [Int] = [Int]()
    
    init(point: (Int, Int)) {
        self.point = point
    }
    
}

