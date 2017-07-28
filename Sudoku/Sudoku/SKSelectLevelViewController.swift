//
//  SKLevelViewController.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/24.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

class SKSelectLevelViewController: SKBaseViewController {

    private var level: SKLevel = .easy
    
    lazy fileprivate var ranks: [SKRank] = [SKRank]()
    
    private var placeView: UIView = {
        let pv = UIView()
        pv.backgroundColor = UIColor.white
        pv.isHidden = true
        let label1 = UILabel()
        label1.textColor = SK_TINTCOLOR
        label1.text = "这是一个需要脑子的游戏！"
        label1.font = UIFont.systemFont(ofSize: 20.0)
        pv.addSubview(label1)
        label1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(pv).offset(-70)
            make.centerX.equalTo(pv)
        })
        
        let label2 = UILabel()
        label2.textColor = SK_TINTCOLOR
        label2.text = "你有脑子吗？"
        label2.font = UIFont.systemFont(ofSize: 20.0)
        pv.addSubview(label2)
        label2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(pv).offset(-10)
            make.centerX.equalTo(pv)
        })
        return pv
    }()
    
    private var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        segment.insertSegment(withTitle: "简单", at: 0, animated: false)
        segment.insertSegment(withTitle: "一般", at: 1, animated: false)
        segment.insertSegment(withTitle: "困难", at: 2, animated: false)
        segment.tintColor = SK_TINTCOLOR
        return segment
    }()
    
    private var tableView: UITableView = {
        let height = SK_SCREEN_HEIGHT - (((SK_SCREEN_WIDTH - 160) / 6) + SK_NAVIGATION_HEIGHT + 165)
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.backgroundColor = UIColor.white
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsets.zero
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SK_SCREEN_WIDTH, height: 0.001))
        table.register(SKRankTableViewCell.self, forCellReuseIdentifier: kSKRankTableViewCell)
        return table
    }()
    
    private var startGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y:  SK_SCREEN_HEIGHT - 80, width: SK_SCREEN_WIDTH - 100, height: 50))
        button.setTitle("开始", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22.0)
        button.setTitleColor(SK_TINTCOLOR, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = SK_TINTCOLOR.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var rankLabel: UILabel = {
        let label = UILabel()
        label.text = "排行榜"
        label.frame = CGRect.init(x: 80, y: (SK_SCREEN_WIDTH - 160) / 6 + SK_NAVIGATION_HEIGHT + 30, width: SK_SCREEN_WIDTH - 160, height: 26)
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = SK_TINTCOLOR
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    
        addAllSubviews()
        segmentControl.addTarget(self, action: #selector(segmentClick), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        tableView.dataSource = self
        tableView.delegate = self
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequestRanks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.rowHeight = tableView.bounds.height / 10
    }
    
    private func fetchRequestRanks() {
        ranks.removeAll()
        
        var key: String = ""
        switch level {
        case .easy:
            key = SK_EASY_TIMES
        case .mid:
            key = SK_MID_TIMES
        case .hard:
            key = SK_HARD_TIMES
        }
        let results = SKCoredataManager.share.fetchRequest(level: key, entityName: "SKRank", type: SKRank.self, key: "seconds", ascending: true)
        ranks.append(contentsOf: results)
        placeView.isHidden = ranks.count != 0
        tableView.reloadData()
    }
    
    private func addAllSubviews() {
        view.addSubview(segmentControl)
        view.addSubview(rankLabel)
        view.addSubview(startGameButton)
        view.addSubview(tableView)
        view.addSubview(placeView)
        
        segmentControl.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.view).offset(SK_NAVIGATION_HEIGHT + 20)
            make.width.equalTo(210)
            make.height.equalTo(210 / 6)
            make.centerX.equalTo(self.view)
        }
        
        rankLabel.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.segmentControl.snp.bottom).offset(20)
            make.centerX.equalTo(self.segmentControl)
        }
        
        startGameButton.snp.makeConstraints { [unowned self](make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-30)
            make.width.equalTo(210)
            make.height.equalTo(42)
            make.centerX.equalTo(self.view)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.rankLabel.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.startGameButton.snp.top).offset(-20)
        }
        
        placeView.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.tableView).offset(1)
            make.bottom.equalTo(self.tableView).offset(-1)
            make.left.right.equalTo(self.tableView)
        }
        
    }
    
    @objc private func segmentClick() {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                level = .easy
            case 1:
                level = .mid
            case 2:
                level = .hard
            default:
                break
        }
        fetchRequestRanks()
    }
    
    @objc private func startGame() {
        let sk = Sudoku(level: level)
        sk.showSudoku()
        let vc = SKGameViewController(level: level, sudoku: sk)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SKSelectLevelViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranks.count > 10 ? 10 : ranks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SKRankTableViewCell()
        cell.model = ranks[indexPath.row]
        cell.rankLabel.text = "\(indexPath.row + 1)."
        return cell
    }
    
}



