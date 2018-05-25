//
//  GTMGameLevelManager.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//
import Foundation

class GTMGameLevelManager {
    var level: GTMLevelCD!
    private var swaps = 0
    private var life = 0
    private var wasRightAnswers = 0
    
    var didEndGame: ((_ userWin: Bool) -> Void)?
    
    init(level: GTMLevelCD) {
        self.level = level
        self.life = Int(level.life)
        self.swaps = Int(level.swaps)
    }
    
    func getSongDuration() -> Int {
        return Int(level.timeToAnswer)
    }
    
    func getSwaps() -> Int {
        return swaps
    }
    
    func getLife() -> Int {
        return life
    }
    
    func totalLives() -> Int {
        return Int(level.life)
    }
    
    func totalAnswers() -> Int {
        return Int(level.numberOfAnswers)
    }
    
    func userDidSwap() {
        swaps -= 1
    }
    
    func getNumberOfAnswers() -> Int {
        return wasRightAnswers
    }
    
    func userDidWrongAnswer() {
        life -= 1
        if life <= 0 {
            self.didEndGame?(false)
        }
    }
    
    func reset() {
        self.life = Int(level.life)
        self.swaps = Int(level.swaps)
        self.wasRightAnswers = 0
    }
    
    func userDidRightAnswer() {
        wasRightAnswers += 1
        if Int(level.numberOfAnswers) == wasRightAnswers {
            self.didEndGame?(true)
        }
    }
    
    func gameStatics() -> GTMLevelStat {
        return calculateStatistics()
    }
    
    private func calculateStatistics() -> GTMLevelStat {
        return GTMLevelStat()
    }
}
