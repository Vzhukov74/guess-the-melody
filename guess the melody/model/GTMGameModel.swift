//
//  GTMGameModel.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import SwiftyBeaver

typealias GTMAnswerData = (songName: String, authorName: String)

class GTMGameModel: NSObject {
    
    private let questionStore = GTMQuestionManager()
    private var level: GTMGameLevelManager!
    
    private var nextQuestion: GTMQuestion?
    private var currentQuestion: GTMQuestion!
    private var currentAnswers = [GTMAnswer]()
    
    private var preloadPlayer = AVPlayer()
    private var songPlayer = AVPlayer()
    private var observerContext = 0
    
    private var isLoading = false
    
    private var timer: GTMTimer?
    
    private var state: GTMGameState! {
        didSet {
            switch state {
            case .initing: return
            case .preparing:
                setQuestion()
                isLoading = true
                self.updateUI?(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
            case .listening:
                isLoading = false
                timer = GTMTimer(time: level.getSongDuration())
                timer?.updateTime = { (time) in
                    self.updateTime?(time)
                }
                timer?.timeIsOver = { [weak self] in
                    self?.state = .countdown
                }
                timer?.toggle()
            case .countdown:
                songPlayer.pause()
                SwiftyBeaver.debug("state is countdown")
                timer = GTMTimer(time: 3)
                timer?.updateTime = { (time) in
                    self.updateTime?(time)
                }
                timer?.timeIsOver = { [weak self] in
                    self?.state = .preparing
                }
                timer?.toggle()
            case .stop: return
            case .none:
                return
            case .some(_):
                return
            }
        }
    }
    
    var updateUI: ((_ swaps: Int, _ life: Int, _ rightAnswers: Int) -> Void)?
    var updateTime: ((_ time: String) -> Void)?
    
    init(level: GTMGameLevelManager) {
        super.init()
        self.level = level
        self.state = .initing
    }
    
    func startGame() {
        self.state = .preparing
    }
    
    func stopGame() {
        self.state = .stop
    }
    
    private func setQuestion() {
        if nextQuestion == nil {
            guard let question1 = questionStore.getQuestion() else { return }
            guard let question2 = questionStore.getQuestion() else { return }
            
            self.currentQuestion = GTMQuestion()
            self.currentQuestion.setData(data: question1)
            self.nextQuestion = GTMQuestion()
            self.nextQuestion?.setData(data: question2)
            
            songPlayer = setPlayerFor(question: currentQuestion)
            preloadPlayer = setPlayerFor(question: nextQuestion!)
        } else {
            guard let question1 = questionStore.getQuestion() else { return }
            self.currentQuestion = self.nextQuestion
            self.nextQuestion = GTMQuestion()
            self.nextQuestion?.setData(data: question1)
            self.songPlayer = self.preloadPlayer
            preloadPlayer = setPlayerFor(question: nextQuestion!)
        }
        
        currentAnswers = [currentQuestion.rightAnswer!, currentQuestion.wrongAnswers[0], currentQuestion.wrongAnswers[1], currentQuestion.wrongAnswers[2]]
        
        currentAnswers = GTMHelper.randomizeArray(array: currentAnswers)
        
        songPlayer.addObserver(self, forKeyPath: "reasonForWaitingToPlay", options: .new, context: &observerContext)
        songPlayer.play()
    }
    
    private func setPlayerFor(question: GTMQuestion) -> AVPlayer {
        guard let url = question.rightAnswer?.songUrl, !url.isEmpty else { return AVPlayer() }
        
        let item = AVPlayerItem(url: NSURL(string: url)! as URL)
        let player = AVPlayer(playerItem: item)
        return player
    }
    
    func answerFor(index: Int) -> GTMAnswerData {
        let answer = currentAnswers[index]
        
        return (songName: answer.songName, authorName: answer.author)
    }
    
    func imageURLForQuestion() -> URL? {
        return URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Features/6f/c2/e0/dj.mlahzdak.jpg/1200x630bb.jpg")
    }
    
    func userDidAnswer(index: Int) {
        songPlayer.pause()
        let answer = currentAnswers[index]
        if answer.songUrl == currentQuestion.rightAnswer!.songUrl {
            SwiftyBeaver.debug("it is correct answer")
            level.userDidRightAnswer()
        } else {
            SwiftyBeaver.debug("it is incorrect answer")
            level.userDidRightAnswer()
        }
        self.state = .preparing
    }
    
    func userDidSwap() {
        songPlayer.pause()
        level.userDidSwap()
        self.state = .preparing
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == "reasonForWaitingToPlay" {
            if change![.newKey] is NSNull {
                self.state = .listening
            }
            SwiftyBeaver.debug("reasonForWaitingToPlay is \(String(describing: change![.newKey]))")
        }
    }
    
    deinit {
        songPlayer.removeObserver(self, forKeyPath: "reasonForWaitingToPlay")
        
        print("dainit - GTMGameModel")
    }
}

extension GTMGameModel {
    
}
