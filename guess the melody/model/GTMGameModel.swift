//
//  GTMGameModel.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMAnswer {
    var author: String = ""
    var songName: String = ""
    var albumImageUrl: String = ""
    var songUrl: String = ""
    
    func setData(author : String, songName : String, albumImageUrl : String, songUrl : String) {
        self.author = author
        self.songName = songName
        self.albumImageUrl = albumImageUrl
        self.songUrl = songUrl
    }
    
    func setData(data : [String : AnyObject]) {
        self.author = data["author"] as? String ?? ""
        self.songName = data["songName"] as? String ?? ""
        self.albumImageUrl = data["albumImageUrl"] as? String ?? ""
        self.songUrl = data["songUrl"] as? String ?? ""
    }
}

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
}



class GTMCameLevelManager {
    private var level: GTMCameLevel!
    
    private var currentQuestion: GTMQuestion!
    
    init(level: GTMCameLevel) {
        self.level = level
        currentQuestion = GTMQuestion()
    }
}

typealias GTMAnswerData = (songName: String, authorName: String)

class GTMGameModel {
    
    private let questionStore = GTMQuestionManager()
    private var level: GTMCameLevelManager!
    private var currentQuestion = GTMQuestion()
    private var currentAnswers = [GTMAnswer]()
    
    var setUIForQuestion: (() -> Void)?
    
    init(level: GTMCameLevelManager) {
        self.level = level
        
        setQuestion()
    }
    
    private func setQuestion() {
        guard let question = questionStore.getQuestion() else { return }
        currentQuestion = GTMQuestion()
        
        currentQuestion.isPassed = question.isPassed
        currentQuestion.url = question.url!
        
        currentQuestion.rightAnswer = setAnswer(answer: question.rightAnswer!)
        let wrongAnswers =  question.wrongAnswers!.allObjects as! [GTMAnswerCD]
        currentQuestion.wrongAnswers = [setAnswer(answer: wrongAnswers[0]), setAnswer(answer: wrongAnswers[1]), setAnswer(answer: wrongAnswers[2])]
        
        currentAnswers = [currentQuestion.rightAnswer!, currentQuestion.wrongAnswers[0], currentQuestion.wrongAnswers[1], currentQuestion.wrongAnswers[2]]
    }
    
    private func setAnswer(answer: GTMAnswerCD) -> GTMAnswer {
        let _answer = GTMAnswer()
        _answer.author = answer.author!
        _answer.songUrl = answer.songUrl!
        _answer.songName = answer.songName!
        _answer.albumImageUrl = answer.albumImageUrl!
        return _answer
    }
    
    func answerFor(index: Int) -> GTMAnswerData {
        let answer = currentAnswers[index]
        
        return (songName: answer.songName, authorName: answer.author)
    }
    
    func imageURLForQuestion() -> URL? {
        return URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Features/6f/c2/e0/dj.mlahzdak.jpg/1200x630bb.jpg")
    }
    
    func userDidAnswer(index: Int) {
        setQuestion()
        self.setUIForQuestion?()
    }
    
    func userDidSwap() {
        setQuestion()
        self.setUIForQuestion?()
    }
}
