//
//  LevelCell.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell, CellRegistable, CellDequeueReusable {

    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var starView: UIView! {
        didSet {
            starView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var levelNumberLabel: UILabel! {
        didSet {
            levelNumberLabel.type = .cellTitle
        }
    }
    
    @IBOutlet weak var livesLabel: UILabel! {
        didSet {
            livesLabel.type = .cellInfo
        }
    }
    
    @IBOutlet weak var swapLabel: UILabel! {
        didSet {
            swapLabel.type = .cellInfo
        }
    }
    
    @IBOutlet weak var answersLabel: UILabel! {
        didSet {
            answersLabel.type = .cellInfo
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.type = .cellInfo
        }
    }

    @IBOutlet weak var livesTitleLabel: UILabel! {
        didSet {
            livesTitleLabel.type = .cellInfoLabel
        }
    }
    
    @IBOutlet weak var swapTitleLabel: UILabel! {
        didSet {
            swapTitleLabel.type = .cellInfoLabel
        }
    }
    
    @IBOutlet weak var answersTitleLabel: UILabel! {
        didSet {
            answersTitleLabel.type = .cellInfoLabel
        }
    }
    
    @IBOutlet weak var timeTitleLabel: UILabel! {
        didSet {
            timeTitleLabel.type = .cellInfoLabel
        }
    }
    
    @IBOutlet weak var lockLabel: UILabel! {
        didSet {
            lockLabel.type = .cellLockTitle
            lockLabel.numberOfLines = 2
            lockLabel.text = "Level is locked\n you must pass previous levels!"
        }
    }
    
    @IBOutlet weak var lockView: UIView! {
        didSet {
            lockView.layer.cornerRadius = 4
            lockView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
    }
    
    @IBOutlet weak var starImg1: UIImageView! {
        didSet {
            starImg1.tintColor = Colors.starHidden
        }
    }
    
    @IBOutlet weak var starImg2: UIImageView! {
        didSet {
            starImg2.tintColor = Colors.starHidden
        }
    }    
    
    @IBOutlet weak var starImg3: UIImageView! {
        didSet {
            starImg3.tintColor = Colors.starHidden
        }
    }
    
    func configure(level: GTMLevelCD) {
        if level.isOpen {
            lockLabel.isHidden = true
            lockView.isHidden = true
        } else {
            lockLabel.isHidden = false
            lockView.isHidden = false
        }
        
        levelNumberLabel.text = "Level - \(level.id)"
        livesLabel.text = "\(level.life)"
        swapLabel.text = "\(level.swaps)"
        answersLabel.text = "\(level.numberOfAnswers)"
        timeLabel.text = "\(level.timeToAnswer)"
        
        let stars = level.levelStat?.stars ?? 4
        configureStar(stars: Int(stars))
    }
    
    private func configureStar(stars: Int) {
        switch stars {
        case 0:
            starImg1.tintColor = Colors.starOff
            starImg2.tintColor = Colors.starOff
            starImg3.tintColor = Colors.starOff
        case 1:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOff
            starImg3.tintColor = Colors.starOff
        case 2:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOn
            starImg3.tintColor = Colors.starOff
        case 3:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOn
            starImg3.tintColor = Colors.starOn
        default:
            starImg1.tintColor = Colors.starHidden
            starImg2.tintColor = Colors.starHidden
            starImg3.tintColor = Colors.starHidden
        }
    }
}
