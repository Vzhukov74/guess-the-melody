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
    
    private var currentQuestion: GTMQuestion!
    private var currentAnswers = [GTMAnswer]()
    
    private var timer: GTMTimer?
    private let player = GTMPlayer()
    
    private var state: GTMGameState! {
        didSet {
            switch state {
            case .initing: return
            case .preparing:
                setQuestion()
                self.updateUI?(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
            case .listening:
                timer = GTMTimer(time: level.getSongDuration())
                timer?.updateTime = { (time) in
                    self.updateTime?(time)
                }
                timer?.timeIsOver = { [weak self] in
                    self?.state = .countdown
                }
                timer?.toggle()
            case .countdown:
                player.stop()
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
        guard let question = questionStore.getQuestion() else { return }
        self.currentQuestion = GTMQuestion()
        self.currentQuestion.setData(data: question)
        
        currentAnswers = [currentQuestion.rightAnswer!, currentQuestion.wrongAnswers[0], currentQuestion.wrongAnswers[1], currentQuestion.wrongAnswers[2]]
        
        currentAnswers = GTMHelper.randomizeArray(array: currentAnswers)
        
        player.delegate = self
        player.setSongBy(urlStr: currentQuestion.rightAnswer?.songUrl ?? "")
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
        player.stop()
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
        player.stop()
        level.userDidSwap()
        self.state = .preparing
    }
    
    deinit {
        print("dainit - GTMGameModel")
    }
}

extension GTMGameModel: GTMPlayerDelegate {
    func startLoad() {
        
    }
    func endLoad() {
        self.player.start()
    }
    func error() {
        SwiftyBeaver.error("player load with error")
    }
}
