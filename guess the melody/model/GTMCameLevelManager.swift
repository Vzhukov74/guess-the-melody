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
            calculateStatistics()
            self.didEndGame?(true)
        }
    }

    func calculateStatistics() {
        let statistics = GTMLevelStatCD(context: GTMCoreDataManager.shared.managedObjectContext)
        
        let numberOfError = Int(level.life) - life
        let numberOfSwaps = Int(level.swaps) - swaps
        
        statistics.numberOfError = Int64(numberOfError)
        statistics.numberOfSwaps = Int64(numberOfSwaps)
        statistics.score = Int64(calculateScore(numberOfSwap: numberOfSwaps, numberOfError: numberOfError))
        statistics.stars = Int64(calculateStars(numberOfSwap: numberOfSwaps, numberOfError: numberOfError))
        
        level.levelStat = statistics
    }
    
    func getResult() -> GTMLevelStatCD? {
        return level.levelStat
    }
    
    private func calculateStars(numberOfSwap: Int, numberOfError: Int) -> Int {
        
        let swaps = Int(level.swaps) - numberOfSwap
        
        if swaps == 0 && numberOfError == 0 {
            return 3
        } else if numberOfSwap < 2 && numberOfError < 2 {
            return 2
        } else {
            return 1
        }
    }
    
    private func calculateScore(numberOfSwap: Int, numberOfError: Int) -> Int {
        var score = Int(level.life) * 30 + Int(level.swaps) * 15
        score -= numberOfSwap * 10 + numberOfError * 25
        
        return Int(score)
    }
}
