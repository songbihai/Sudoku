//
//  SKDataManager.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/24.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

enum SKLevel: Int {
    case easy = 2
    case mid = 4
    case hard = 6
}

class Sudoku: NSObject {
    
    var level: SKLevel
    
    var sudokuDatas: [[SKModel]]
    
    init(level: SKLevel) {
        
        self.level = level
        self.sudokuDatas = [[SKModel]]()
        
        super.init()
        
        for i in 0..<9 {
            for j in 0..<9 {
                let model = SKModel(point: (i, j))
                if self.sudokuDatas.count - 1 < i {
                    var models = [SKModel]()
                    models.append(model)
                    self.sudokuDatas.append(models)
                }else {
                    self.sudokuDatas[i].append(model)
                }
            }
        }
        self.createMatrix()
        self.fillBlank()
    }
    
    
    func showSudoku() {
        for i in 0..<9 {
            for j in 0..<9 {
                if !sudokuDatas[i][j].isBlank {
                    print(sudokuDatas[i][j].value, terminator: " ")
                }else {
                    print(0, terminator: " ")
                }
            }
            print("")
        }
        print("")
    }
    
    private func searchValidValue(point: (Int, Int)) -> Bool {
        
        if sudokuDatas[point.0][point.1].validList.count > 0 {
            
            let size = sudokuDatas[point.0][point.1].validList.count
            let index = Int(arc4random()) % size
            sudokuDatas[point.0][point.1].value = sudokuDatas[point.0][point.1].validList[index]
            sudokuDatas[point.0][point.1].validList.remove(at: index)
            
        }else {
            if point.0 == 0 && point.1 == 0 {
                return false
            }
            
            sudokuDatas[point.0][point.1].value = 0
            
            if point.1 != 0 {
                
                if !searchValidValue(point: (point.0, point.1 - 1)) {
                    return false
                }
                
            }else {
                
                if !searchValidValue(point: (point.0 - 1, 8)) {
                    return false
                }
                
            }
            
            fillInitialValues(point: point)
            
            if !searchValidValue(point: point) {
                return false
            }
            
        }
        
        return true
    }
    
    private func createMatrix() {
        
        for i in 0..<9 {
            for j in 0..<9 {
                fillInitialValues(point: (i, j))
                if !searchValidValue(point: (i, j)) {
                    return
                }
            }
        }
        
    }
    
    private func fillBlank() {
        var i: Int = 0
        var j: Int = 0
        var count: Int = 0
        for k in 0..<9 {
            count = 0
            while count < (level.rawValue + Int(arc4random()) % 2) {
                repeat {
                    i = 3 * (k % 3) + Int(arc4random()) % 3
                    j = 3 * (k / 3) + Int(arc4random()) % 3
                } while sudokuDatas[i][j].isBlank
                count += 1
                sudokuDatas[i][j].isBlank = true
            }
        }
    }
    
    private func fillInitialValues(point: (Int, Int)) {
        for i in 1...9 {
            if isValid(model: sudokuDatas[point.0][point.1], num: i) {
                sudokuDatas[point.0][point.1].validList.append(i)
            }
        }
    }
    
    
    private func isValid(model: SKModel, num: Int) -> Bool {
        
        for i in 0..<9 {
            if i != model.point.1 {
                if num == sudokuDatas[model.point.0][i].value {
                    return false
                }
            }
        }
        
        for i in 0..<9 {
            if i != model.point.0 {
                if num == sudokuDatas[i][model.point.1].value {
                    return false
                }
            }
        }
        
        let x = model.point.0 / 3 * 3 + 1
        let y = model.point.1 / 3 * 3 + 1
        
        for i in -1..<2 {
            for j in -1..<2 {
                if !(((x + i) == model.point.0) && ((y + j) == model.point.1)) {
                    if num == sudokuDatas[x + i][y + j].value {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    
}
