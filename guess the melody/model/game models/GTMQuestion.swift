//
//  GTMQuestion.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMQuestion {
    var url: String = ""
    var rightAnswer: GTMAnswer?
    var wrongAnswers = [GTMAnswer]()
    var isPassed: Bool = false
    
    func setData(rightAnswer : GTMAnswer, wrongAnswers : [GTMAnswer]) {
        self.url = rightAnswer.songUrl
        self.isPassed = false
        self.rightAnswer = rightAnswer
        self.wrongAnswers = wrongAnswers
    }
    
    func setData(data : [String : AnyObject]) {
        
        self.isPassed = false
        
        if let rAnswer = data["rightAnswer"] as? [String : AnyObject] {
            
            let answer = GTMAnswer()
            answer.setData(data: rAnswer)
            
            self.url = answer.songUrl
            self.rightAnswer = answer
        }
        
        if let wAnswers = data["wrongAnswers"] as? [[String : AnyObject]] {
            for wAnswer in wAnswers {
                
                let answer = GTMAnswer()
                answer.setData(data: wAnswer)
                
                wrongAnswers.append(answer)
            }
        }
    }
    
    func setData(data: GTMQuestionCD) {
        self.isPassed = data.isPassed
        self.url = data.url!
        
        self.rightAnswer = setAnswer(answer: data.rightAnswer!)
        let wrongAnswers =  data.wrongAnswers!.allObjects as! [GTMAnswerCD]
        self.wrongAnswers = [setAnswer(answer: wrongAnswers[0]), setAnswer(answer: wrongAnswers[1]), setAnswer(answer: wrongAnswers[2])]
    }
    
    private func setAnswer(answer: GTMAnswerCD) -> GTMAnswer {
        let _answer = GTMAnswer()
        _answer.author = answer.author!
        _answer.songUrl = answer.songUrl!
        _answer.songName = answer.songName!
        _answer.albumImageUrl = answer.albumImageUrl!
        return _answer
    }
}
