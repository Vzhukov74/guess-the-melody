//
//  GTMGameModel.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import SwiftyBeaver

typealias GTMAnswerData = (songName: String, authorName: String)

class GTMGameModel: NSObject {
    private let questionStore = GTMQuestionManager()
    private var level: GTMGameLevelManager!
    
    private var question: GTMQuestionCD!
    private var currentQuestion: GTMQuestion!
    private var currentAnswers = [GTMAnswer]()
    
    private var timer: GTMTimer?
    private let player = GTMPlayer()
    
    private var previousState: GTMGameState = .initing
    private var state: GTMGameState! {
        didSet {
            switch state {
            case .initing: return
            case .preparing:
                self.timer?.pause()
                startStopSpin?(false)
                updateTime?("--")
                self.updateUI?(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
                timer = GTMTimer(time: level.getSongDuration())
                updateTime?(GTMTimerFormatter.timeAsStringFor(time: Double(level.getSongDuration())))
                timer?.updateTime = { [weak self] (time) in
                    DispatchQueue.main.async {
                        self?.updateTime?(time)
                    }
                }
                timer?.timeIsOver = { [weak self] in
                    DispatchQueue.main.async {
                        self?.state = .prepareCountdown
                    }
                }
            case .listening:
                startStopSpin?(true)
                player.start()
                timer?.toggle()
            case .prepareCountdown:
                player.stop()
                timer = GTMTimer(time: 3)
                updateTime?(GTMTimerFormatter.timeAsStringFor(time: 3))
                timer?.updateTime = { (time) in
                    DispatchQueue.main.async {
                        self.updateTime?(time)
                    }
                }
                timer?.timeIsOver = { [weak self] in
                    DispatchQueue.main.async {
                        self?.level.userDidWrongAnswer()
                        self?.timeIsOver?()
                    }
                }
                setCountdownState()
            case .countdown:
                startStopSpin?(true)
                timer?.toggle()
            case .stop:
                startStopSpin?(false)
                player.stop()
                timer?.pause()
            case .none:
                return
            case .some(_):
                return
            }
        }
    }
    
    var isGameOnPause: Bool {
        return (state == .stop)
    }
    var updateUI: ((_ swaps: Int, _ life: Int, _ rightAnswers: Int) -> Void)?
    var updateTime: ((_ time: String) -> Void)?
    var startStopSpin: ((_ isSpinning: Bool) -> Void)?
    var startStopLoading: ((_ isLoading: Bool) -> Void)?
    var timeIsOver: (() -> Void)?
    var gameOver: ((_ isUserWin: Bool) -> Void)?
    var itWasLastLevel: (() -> Void)?
    
    init(level: GTMGameLevelManager) {
        super.init()
        self.level = level
        self.state = .initing
        
        self.level.didEndGame = { [weak self] isUserWin in
            self?.gameOver?(isUserWin)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopGame), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func setNextLevel() {
        if let _level = GTMLevelsHelper.shared.getNextLevelFor(level: level.level) {
            level = GTMGameLevelManager(level: _level)
            self.updateUI?(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
            self.updateTime?("--")
        } else {
            self.itWasLastLevel?()
        }
    }
    
    func playAgain() {
        level.reset()
        self.updateUI?(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
        self.updateTime?("--")
    }
    
    func setNextQuestion() {
        setQuestion()
    }
    
    func startGame() {
        setQuestion()
    }
    
    @objc func stopGame() {
        previousState = state
        state = .stop
    }
    
    func continueGame() {
        state = previousState
    }
    
    func gameStatics() -> GTMLevelStat {
        return level.gameStatics()
    }
    
    private func setQuestion() {
        guard let question = questionStore.getQuestion() else { return }
        self.question = question
        self.currentQuestion = GTMQuestion()
        self.currentQuestion.setData(data: question)
        
        currentAnswers = [currentQuestion.rightAnswer!, currentQuestion.wrongAnswers[0], currentQuestion.wrongAnswers[1], currentQuestion.wrongAnswers[2]]
        
        currentAnswers = GTMHelper.randomizeArray(array: currentAnswers)
        
        player.delegate = self
        player.setSongBy(urlStr: currentQuestion.rightAnswer?.songUrl ?? "")
        self.state = .preparing
    }

    private func setCountdownState() {
        state = .countdown
    }
    
    func answerFor(index: Int) -> GTMAnswerData {
        let answer = currentAnswers[index]
        
        return (songName: answer.songName, authorName: answer.author)
    }

    func userDidAnswer(index: Int) -> Bool? {
        guard !isGameOnPause else {
            return nil
        }
        
        player.stop()
        
        let answer = currentAnswers[index]
        let isCorrect = (answer.songUrl == currentQuestion.rightAnswer!.songUrl)
        
        if isCorrect {
            DispatchQueue.main.async {
                self.questionStore.setQuestionAsPassed(question: self.question)
            }
            level.userDidRightAnswer()
        } else {
            level.userDidWrongAnswer()
        }
        self.state = .preparing
        
        return isCorrect
    }
    
    func userDidSwap() {
        guard !isGameOnPause else {
            return
        }
        
        player.stop()
        timer?.pause()
        level.userDidSwap()
        setQuestion()
    }
    
    func totalLives() -> Int {
        return level.totalLives()
    }
    
    func totalAnswers() -> Int {
        return level.totalAnswers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dainit - GTMGameModel")
    }
}

extension GTMGameModel: GTMPlayerDelegate {
    func startLoad() {
        self.startStopLoading?(true)
    }
    
    func endLoad() {
        self.state = .listening
        self.startStopLoading?(false)
    }
    
    func error() {
        SwiftyBeaver.error("player load with error")
    }
}
