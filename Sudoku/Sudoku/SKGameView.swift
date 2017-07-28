//
//  SKGameView.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/27.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

protocol SKGameViewDelegate: NSObjectProtocol {
    func didSelectedSubview(model: SKModel?)
    func successful()
}

class SKGameView: UIView {

    weak var delegate: SKGameViewDelegate?
    
    var sudoku: Sudoku
    
    init(frame: CGRect, sudoku: Sudoku) {
        self.sudoku = sudoku
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fillAllSubviews()
        createMatrixView()
    }
    
    func prompt(model: SKModel) {
        fillOneNum(model: model, num: model.value)
        reduction(model: model, isPop: true)
        reloadData()
    }
    
    func noteNumber(model: SKModel, num: Int) {
        if let subview = viewWithTag(model.point.0 * 10 + model.point.1 + 100) as? SKSubview, !subview.noteNumbers.contains(num) {
            subview.noteNumbers.append(num)
        }
    }
    
    func rubberNumbers(model: SKModel) {
        if let subview = viewWithTag(model.point.0 * 10 + model.point.1 + 100) as? SKSubview {
            subview.noteNumbers.removeAll()
        }
    }
    
    @discardableResult
    func fillOneNum(model: SKModel, num: Int) -> Bool {
        if sudoku.sudokuDatas[model.point.0][model.point.1].isBlank {
            if sudoku.sudokuDatas[model.point.0][model.point.1].value == num {
                sudoku.sudokuDatas[model.point.0][model.point.1].isBlank = false
                allAssociated(model: model)
                sudoku.sudokuDatas[model.point.0][model.point.1].state = .selected
                reloadData()
                return true
            }else {
                allAssociated(model: model)
                popError(num: num)
                sudoku.sudokuDatas[model.point.0][model.point.1].state = .selected
                reloadData()
                return false
            }
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        var flag = false
        for i in 0..<9 {
            for j in 0..<9 {
                if let subview = viewWithTag(i * 10 + j + 100) as? SKSubview {
                    subview.model = sudoku.sudokuDatas[i][j]
                    if !flag {
                        flag = sudoku.sudokuDatas[i][j].isBlank
                    }
                }
            }
        }
        if !flag {
            delegate?.successful()
        }
    }
    
    private func fillAllSubviews() {
        let w = frame.width / 9
        for i in 0..<9 {
            for j in 0..<9 {
                let subview = SKSubview(frame: CGRect(x: w * CGFloat(j), y: w * CGFloat(i), width: w, height: w))
                subview.model = sudoku.sudokuDatas[i][j]
                subview.addTarget(self, action: #selector(subviewClick(sender:)), for: .touchUpInside)
                subview.tag = i * 10 + j + 100
                addSubview(subview)
            }
        }
    }
    
    @objc private func subviewClick(sender: SKSubview) {
        guard let m = sender.model else {
            return
        }
        if m.isBlank {
            allAssociated(model: m)
            sudoku.sudokuDatas[m.point.0][m.point.1].state = .selected
        }else {
            reduction(model: m, isPop: false)
        }
        reloadData()
        delegate?.didSelectedSubview(model: m)
    }
    
    private func allAssociated(model: SKModel) {
        reduction(model: nil, isPop: false)
        for i in 0..<9 {
            if i != model.point.1 {
                sudoku.sudokuDatas[model.point.0][i].state = .associated
            }
        }
        
        for i in 0..<9 {
            if i != model.point.0 {
                sudoku.sudokuDatas[i][model.point.1].state = .associated
            }
        }
        
        let x = model.point.0 / 3 * 3 + 1
        let y = model.point.1 / 3 * 3 + 1
        
        for i in -1..<2 {
            for j in -1..<2 {
                if !(((x + i) == model.point.0) && ((y + j) == model.point.1)) {
                    sudoku.sudokuDatas[x + i][y + j].state = .associated
                }
            }
        }
    }
    
    private func reduction(model: SKModel?, isPop: Bool) {
        for i in 0..<9 {
            for j in 0..<9 {
                if let m = model, m.value == sudoku.sudokuDatas[i][j].value, sudoku.sudokuDatas[i][j].isBlank == false {
                    sudoku.sudokuDatas[i][j].state = .selected
                }else if !isPop {
                    sudoku.sudokuDatas[i][j].state = .normal
                }
            }
        }
    }
    
    private func popError(num: Int) {
        for i in 0..<9 {
            for j in 0..<9 {
                if num == sudoku.sudokuDatas[i][j].value, sudoku.sudokuDatas[i][j].isBlank == false {
                    sudoku.sudokuDatas[i][j].state = .error
                }
            }
        }
    }
    
    private func createMatrixView() {
        
        let w: CGFloat = frame.width / 9
        for i in 0...9 {
            let lineView = UIView(frame: CGRect(x: 0, y: CGFloat(i) * w, width: bounds.width, height: 1))
            if i % 3 == 0 {
                lineView.backgroundColor = UIColor.black
            }else {
                lineView.backgroundColor = UIColor.rgba(r: 186, g: 186, b: 186)
            }
            addSubview(lineView)
        }
        for j in 0...9 {
            let lineView = UIView(frame: CGRect(x: CGFloat(j) * w, y: 0, width: 1, height: bounds.width))
            if j % 3 == 0 {
                lineView.backgroundColor = UIColor.black
            }else {
                lineView.backgroundColor = UIColor.rgba(r: 186, g: 186, b: 186)
            }
            addSubview(lineView)
        }
    }

}

class SKSubview: UIButton {
    
    var model: SKModel? {
        didSet {
            if let m = model, !m.isBlank {
                skLabel.isHidden = false
                noteNumbers.removeAll()
                skLabel.text = "\(m.value)"
            }else {
                skLabel.text = ""
            }
            guard let m = model else {
                return
            }
            switch m.state {
                case .normal:
                    backgroundColor = UIColor.white
                case .associated:
                    backgroundColor = UIColor.rgba(r: 250, g: 231, b: 201)
                case .error:
                    backgroundColor = UIColor.rgba(r: 240, g: 63, b: 71)
                case .selected:
                    backgroundColor = UIColor.rgba(r: 252, g: 191, b: 140)
            }
        }
    }
    
    var noteNumbers: [Int] = [Int]() {
        didSet {
            skLabel.isHidden = noteNumbers.count != 0
            if noteNumbers.count == 0 {
                for i in 0..<9 {
                    let label = viewWithTag(i + 1000) as? UILabel
                    guard let lab = label else {
                        return
                    }
                    lab.isHidden = true
                    lab.text = ""
                }
            }else {
                noteNumbers.forEach { (num) in
                    let label = viewWithTag(num - 1 + 1000) as? UILabel
                    guard let lab = label else {
                        return
                    }
                    lab.isHidden = false
                    lab.text = "\(num)"
                }
            }
        }
    }
    
    private var skLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
    }
    
    private func addAllSubviews() {
        let w = frame.width / 3
        for i in 0..<9 {
            let j = i % 3
            let label = UILabel(frame: CGRect(x: w * CGFloat(j), y: w * CGFloat(i / 3), width: w, height: w))
            label.textColor = UIColor.rgba(r: 123, g: 210, b: 153)
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.tag = i + 1000
            label.isHidden = true
            label.textAlignment = .center
            addSubview(label)
        }
        skLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.width))
        skLabel.textColor = UIColor.black
        skLabel.font = UIFont.systemFont(ofSize: 20.0)
        skLabel.textAlignment = .center
        addSubview(skLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
