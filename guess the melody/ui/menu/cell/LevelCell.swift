//
//  LevelCell.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell, CellRegistable, CellDequeueReusable {

    @IBOutlet weak var levelNumber: UILabel! {
        didSet {
            
        }
    }
    
    
    
    func configure(level: GTMLevelCD) {
        levelNumber.text = "Level - \(level.id)"
    }
}
