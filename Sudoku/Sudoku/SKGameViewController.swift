//
//  SKGameViewController.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/24.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

private let width = SK_SCREEN_WIDTH - 100

class SKGameViewController: SKBaseViewController {

    var level: SKLevel
    
    var sudoku: Sudoku
    
    fileprivate var model: SKModel?
    
    fileprivate var count: Int = 0
    
    fileprivate var timer: Timer?
    
    private var selectedPoint: (Int, Int)?
    
    fileprivate var fewTimes: Int? {
        didSet {
            guard let f = fewTimes, f > 0 else {
                fewTimesLabel.text = "第1关"
                fewTimes = 1
                return
            }
            fewTimesLabel.text = "第\(f)关"
        }
    }
    
    private var fewTimesLabel: UILabel = {
        let label = UILabel()
        label.textColor = SK_TINTCOLOR
        return label
    }()
    
    fileprivate var pencilButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (SK_SCREEN_WIDTH - 120) / 4, y: SK_SCREEN_HEIGHT - 70, width: 40, height: 40))
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.init(named: "铅笔"), for: .normal)
        return button
    }()


    private var promptButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (SK_SCREEN_WIDTH - 120) / 2 + 40, y: SK_SCREEN_HEIGHT - 70, width: 40, height: 40))
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.init(named: "搜索"), for: .normal)
        return button
    }()
    
    private var rubberButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (SK_SCREEN_WIDTH - 120) / 4 * 3 + 80, y: SK_SCREEN_HEIGHT - 74, width: 40, height: 40))
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.init(named: "橡皮擦"), for: .normal)
        return button
    }()
    
    lazy fileprivate var gameView: SKGameView = {
        let game = SKGameView(frame: CGRect.zero, sudoku: self.sudoku)
        return game
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back1"), for: .normal)
        return button
    }()
    
    fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .right
        label.text = "00:00"
        return label
    }()
    
    
    init(level: SKLevel, sudoku: Sudoku) {
        self.level = level
        self.sudoku = sudoku
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch level {
            case .easy:
                titleLabel.text = "简单"
            case .mid:
                titleLabel.text = "一般"
            case .hard:
                titleLabel.text = "困难"
        }
        
        addAllSubviews()
        backButton.addTarget(self, action: #selector(backViewControl), for: .touchUpInside)
        
        pencilButton.addTarget(self, action: #selector(toNoteNumbers), for: .touchUpInside)
        
        promptButton.addTarget(self, action: #selector(promptOneNumber), for: .touchUpInside)
        
        rubberButton.addTarget(self, action: #selector(rubberNumbers), for: .touchUpInside)
        
        gameView.delegate = self
        
        timer = Timer.sb_scheduledTimerWithTimeInterval(ti: 1, block: { [unowned self]in
            self.count = self.count + 1
            self.timeLabel.text = self.timeToString()
        }, repeats: true)
        
    }
    
    private func addAllSubviews() {
        view.addSubview(backButton)
        view.addSubview(gameView)
        view.addSubview(pencilButton)
        view.addSubview(promptButton)
        view.addSubview(rubberButton)
        view.addSubview(timeLabel)
        view.addSubview(fewTimesLabel)
        
        if IS_PAD {
            gameView.snp.makeConstraints({ [unowned self](make) in
                make.top.equalTo(self.view).offset(SK_NAVIGATION_HEIGHT + 70)
                make.width.height.equalTo(SK_SCREEN_HEIGHT - SK_NAVIGATION_HEIGHT - 230)
                make.centerX.equalTo(self.view)
            })
        }else {
            gameView.snp.makeConstraints({ [unowned self](make) in
                make.top.equalTo(self.navigationView.snp.bottom).offset(80)
                make.left.right.equalTo(self.view)
                make.height.equalTo(SK_SCREEN_WIDTH)
            })
        }
        
        backButton.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.view).offset(5)
            make.width.height.equalTo(SK_NAVIGATIONBAR_HEIGHT)
            make.centerY.equalTo(self.navigationView).offset(IS_PHONEX ? 22 : 10)
        }
        
        timeLabel.snp.makeConstraints { [unowned self](make) in
            make.right.equalTo(self.view).offset(-20)
            make.centerY.equalTo(self.backButton)
        }
        
        fewTimesLabel.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.navigationView.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
        
        addNumberButtons()
        getTimes()
    }
    
    private func getTimes() {
        
        switch level {
            case .easy:
                fewTimes = UserDefaults.standard.integer(forKey: SK_EASY_TIMES)
            case .mid:
                fewTimes = UserDefaults.standard.integer(forKey: SK_MID_TIMES)
            case .hard:
                fewTimes = UserDefaults.standard.integer(forKey: SK_HARD_TIMES)
        }
        
    }
    
    fileprivate func changeNoteSate() {
        if nil != model {
            pencilButton.isSelected = true
            UIView.animate(withDuration: 0.25) {
                self.pencilButton.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 4)
            }
        }else {
            pencilButton.isSelected = false
            UIView.animate(withDuration: 0.25) {
                self.pencilButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc private func promptOneNumber() {
        guard let m = model else {
            return
        }
        gameView.prompt(model: m)
        model = nil
        changeNoteSate()
    }
    
    @objc fileprivate func toNoteNumbers() {
        if nil != model {
            pencilButton.isSelected = !pencilButton.isSelected
            UIView.animate(withDuration: 0.25) {
                if self.pencilButton.isSelected {
                    self.pencilButton.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 4)
                }else {
                    self.pencilButton.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    @objc private func rubberNumbers() {
        guard let m = model else {
            return
        }
        gameView.rubberNumbers(model: m)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeToString() -> String {
        let seconds = count % 60
        let minutes = (count / 60) % 60
        let hours = count / 3600
        var timeString = ""
        if hours > 0 {
            if hours < 10 {
                timeString = "0\(hours)"
            }else {
                timeString = "\(hours)"
            }
        }
        if timeString.isEmpty {
            if minutes < 10 {
                timeString = "0\(minutes)"
            }else {
                timeString = "\(minutes)"
            }
        }else {
            if minutes < 10 {
                timeString += "0\(minutes)"
            }else {
                timeString += "\(minutes)"
            }
        }
        if seconds < 10 {
            timeString += ":" + "0\(seconds)"
        }else {
            timeString += ":" + "\(seconds)"
        }
        return timeString
    }
    
    private func addNumberButtons() {
        let w = SK_SCREEN_WIDTH / 9
        for i in 0..<9 {
            let button = UIButton(frame: CGRect.init(x: w * CGFloat(i), y: SK_SCREEN_HEIGHT - 130, width: w, height: 40))
            button.setTitle("\(i + 1)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Arial-BoldItalicMT", size: 25.0)
            button.setTitleColor(UIColor.rgba(r: 123, g: 210, b: 153), for: .normal)
            button.addTarget(self, action: #selector(senderNumber(sender:)), for: .touchUpInside)
            button.tag = i + 1
            view.addSubview(button)
        }
    }
    
    @objc private func senderNumber(sender: UIButton) {
        guard let m = model else {
            return
        }
        if pencilButton.isSelected {
            //笔记
            gameView.noteNumber(model: m, num: sender.tag)
        }else {
            if gameView.fillOneNum(model: m, num: sender.tag) {
                model = nil
                changeNoteSate()
            }
        }
    }
    
    @objc private func backViewControl() {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension SKGameViewController: SKGameViewDelegate {
    
    func didSelectedSubview(model: SKModel?) {
        if let m = model, m.isBlank {
            self.model = m
        }else {
            self.model = nil
            changeNoteSate()
        }
    }
    
    func successful() {
        
        timer?.fireDate = Date.distantFuture
        
        var key: String = ""
        switch level {
        case .easy:
            key = SK_EASY_TIMES
        case .mid:
            key = SK_MID_TIMES
        case .hard:
            key = SK_HARD_TIMES
        }
        if let f = fewTimes {
            UserDefaults.standard.set(f + 1, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        let popupView = SKSurePopupView.show(title: "你真棒!!!", detailText: "留下你的大名吧", leftText: "返回", rightText: "继续", animated: true)
        
        popupView.leftRightAction(left: {
            if let tf = popupView.nameTextField, let name = tf.text, name.characters.count > 0 {
                if let time = self.timeLabel.text {
                    SKCoredataManager.share.addOneRankEntity(level: key, name: name, time: time, seconds: Int64(self.count))
                }
            }else {
                if let time = self.timeLabel.text {
                    SKCoredataManager.share.addOneRankEntity(level: key, name: "无名氏", time: time, seconds: Int64(self.count))
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }) {
            
            if let tf = popupView.nameTextField, let name = tf.text, name.characters.count > 0 {
                if let time = self.timeLabel.text {
                    SKCoredataManager.share.addOneRankEntity(level: key, name: name, time: time, seconds: Int64(self.count))
                }
            }else {
                if let time = self.timeLabel.text {
                    SKCoredataManager.share.addOneRankEntity(level: key, name: "无名氏", time: time, seconds: Int64(self.count))
                }
            }
            
            self.gameView.sudoku = Sudoku(level: self.level)
            self.count = 0
            self.timeLabel.text = "00:00"
            self.fewTimes = UserDefaults.standard.integer(forKey: key)
            self.gameView.reloadData()
            self.timer?.fireDate = Date()
        }
    }
    
}
