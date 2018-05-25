//
//  LevelCell.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell, CellRegistable, CellDequeueReusable {

    @IBOutlet weak var levelNumberLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var livesLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var swapLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var answersLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var lockLabel: UILabel! {
        didSet {
            lockLabel.text = "Label is lock"
        }
    }
    
    @IBOutlet weak var lockView: UIView! {
        didSet {
            lockView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
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
        livesLabel.text = "Level - \(level.life)"
        swapLabel.text = "Level - \(level.swaps)"
        answersLabel.text = "Level - \(level.numberOfAnswers)"
        timeLabel.text = "Level - \(level.timeToAnswer)"
        
        if level.levelStat != nil {
            
        }
    }
}
