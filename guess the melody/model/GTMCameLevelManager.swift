//
//  GTMCameLevelManager.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMCameLevelManager {
    private var level: GTMCameLevel!
    
    private var currentQuestion: GTMQuestion!
    
    init(level: GTMCameLevel) {
        self.level = level
        currentQuestion = GTMQuestion()
    }
    
    func getSongDuration() -> Int {
        return 10
    }
}
