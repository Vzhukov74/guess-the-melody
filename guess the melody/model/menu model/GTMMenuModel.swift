//
//  GTMMenuModel.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMMenuModel {
    var levels: [GTMLevelCD] {
        get {
            return GTMLevelsManager.shared.levels
        }
    }
    
    var score: Int {
        get {
            return GTMLevelsManager.shared.score()
        }
    }
    
    var progress: Float {
        get {
            return GTMLevelsManager.shared.progress()
        }
    }
    
}
