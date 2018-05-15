//
//  GTMLevel.swift
//  guess the melody
//
//  Created by Vlad on 08.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMCameLevel {
    var id: Int = 0
    var life: Int = 0
    var swaps: Int = 0
    var timeToAnswer: Int = 0
    var numberOfAnswers: Int = 0
    var numberOfQuestions: Int = 0
    var levelStat: GTMLevelStat? = nil
    var isPassed: Bool = false
    var isOpen: Bool = true
    
    func setData(id : Int, life : Int, swaps : Int, timeToAnswer : Int, numberOfAnswers : Int, numberOfQuestions : Int) {
        self.id = id
        self.life = life
        self.swaps = swaps
        self.timeToAnswer = timeToAnswer
        self.numberOfAnswers = numberOfAnswers
        self.numberOfQuestions = numberOfQuestions
    }
    
    func setData(data: [String : AnyObject]) {
        self.id = data["id"] as? Int ?? 0
        self.life = data["life"] as? Int ?? 0
        self.swaps = data["swaps"] as? Int ?? 0
        self.timeToAnswer = data["timeToAnswer"] as? Int ?? 0
        self.numberOfAnswers = data["numberOfAnswers"] as? Int ?? 0
        self.numberOfQuestions = data["numberOfQuestions"] as? Int ?? 0
    }
}

class GTMLevelStat {
    var stars: Int = 0
    var numberOfSwaps: Int = 0
    var numberOfError: Int = 0
    var score: Int = 0
}
