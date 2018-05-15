//
//  GTMGameLevelManager.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//
import Foundation

class GTMGameLevelManager {
    private var level: GTMLevelCD!
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
    
    func userDidSwap() {
        swaps -= 1
    }
    
    func getNumberOfAnswers() -> Int {
        return Int(level.numberOfAnswers)
    }
    
    func userDidWrongAnswer() {
        life -= 1
        if life <= 0 {
            self.didEndGame?(false)
        }
    }
    
    func userDidRightAnswer() {
        wasRightAnswers += 1
        if Int(level.numberOfAnswers) == wasRightAnswers {
            self.didEndGame?(true)
        }
    }
    
    private func calculateStatistics() {
    
    }
}
