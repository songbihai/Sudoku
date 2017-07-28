//
//  SKRankTableViewCell.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/26.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit

let kSKRankTableViewCell: String = "SKRankTableViewCell"

class SKRankTableViewCell: UITableViewCell {

    var model: SKRank? {
        didSet {
            if let m = model {
                nameLabel.text = m.name
                timeLabel.text = m.time
            }
        }
    }
    
    var rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgba(r: 200, g: 36, b: 39)
        label.font = UIFont.systemFont(ofSize: 19.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = SK_TINTCOLOR
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = SK_TINTCOLOR
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addAllSubviews()
    }
    
    private func addAllSubviews() {
        contentView.addSubview(rankLabel)
        contentView.addConstraint(NSLayoutConstraint(item: rankLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: -160))
        contentView.addConstraint(NSLayoutConstraint(item: rankLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addSubview(nameLabel)
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: rankLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addSubview(timeLabel)
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 60))
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: nameLabel, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
