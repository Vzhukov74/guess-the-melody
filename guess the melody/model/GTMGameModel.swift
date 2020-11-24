//
//  GTMGameModel.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

typealias GTMAnswerData = (songName: String, authorName: String)

protocol GTMGameModelDelegate: class {
    func updateUI(_ swaps: Int, _ life: Int, _ rightAnswers: Int)
    func updateTime(_ time: String)
    func startStopSpin(_ isSpinning: Bool)
    func startStopLoading(_ isLoading: Bool)
    func timeIsOver()
    func gameOver(_ isUserWin: Bool)
    func itWasLastLevel()
}

class GTMGameModel {
    private let soundEngine = GTMGameSoundEngine()
    private let questionStore = GTMQuestionsManager()
    private var level: GTMGameLevelManager!
    
    private var question: GTMQuestionCD!
    private var currentQuestion: GTMQuestion!
    private var currentAnswers = [GTMAnswer]()
    
    private var gameState: GTMGameStateManager

    var isGameOnPause: Bool {
        return (gameState.currentState() == .stop)
    }
    
    weak var delegate: GTMGameModelDelegate?
    
    init(level: GTMGameLevelManager) {
        self.level = level
        
        self.gameState = GTMGameStateManager(songTime: level.getSongDuration())
        self.gameState.delegate = self
        
        self.level.didEndGame = { [weak self] isUserWin in
            if isUserWin {
                self?.soundEngine.play(melodyURL: GTMGameSound.levelPass, isVibrationActice: true)
            }
            self?.delegate?.gameOver(isUserWin)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopGame), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setNextLevel() {
        if let _level = GTMLevelsManager.shared.getNextLevelFor(level: level.level) {
            level = GTMGameLevelManager(level: _level)
            self.delegate?.updateUI(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
            self.delegate?.updateTime("--")
            setupGameState()
        } else {
            self.delegate?.itWasLastLevel()
        }
    }
    
    func playAgain() {
        level.reset()
        self.delegate?.updateUI(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
        self.delegate?.updateTime("--")
    }
    
    func setNextQuestion() {
        setQuestion()
    }
    
    func startGame() {
        self.gameState.delegate = self
        setQuestion()
    }
    
    @objc func stopGame() {
        gameState.stopGame()
    }
    
    func continueGame() {
        gameState.continueGame()
    }
    
    func getResult() -> GTMLevelStat {
        let result = GTMLevelStat()
        if let levelResult = level.getResult() {
            result.stars = Int(levelResult.stars)
            result.numberOfError = Int(levelResult.numberOfError)
            result.numberOfSwaps = Int(levelResult.numberOfSwaps)
            result.score = Int(levelResult.score)
        }
        return result
    }
    
    private func setupGameState() {
        self.gameState = GTMGameStateManager(songTime: level.getSongDuration())
        self.gameState.delegate = self
    }
    
    private func setQuestion() {
        guard let question = questionStore.getQuestion() else { return }
        self.question = question
        self.currentQuestion = GTMQuestion()
        self.currentQuestion.setData(data: question)
        
        currentAnswers = [currentQuestion.rightAnswer!, currentQuestion.wrongAnswers[0], currentQuestion.wrongAnswers[1], currentQuestion.wrongAnswers[2]]
        
        currentAnswers = GTMHelper.randomizeArray(array: currentAnswers)
        
        gameState.setSongBy(url: currentQuestion.rightAnswer?.songUrl ?? "")
    }

    func answerFor(index: Int) -> GTMAnswerData {
        let answer = currentAnswers[index]
        
        return (songName: answer.songName, authorName: answer.author)
    }
    
    func userDidAnswer(index: Int) -> Bool? {
        guard !isGameOnPause else {
            return nil
        }
        gameState.didAnswer()
        let answer = currentAnswers[index]
        let isCorrect = (answer.songUrl == currentQuestion.rightAnswer!.songUrl)
        
        if isCorrect {
            soundEngine.play(melodyURL: GTMGameSound.correctAnswer)
            DispatchQueue.main.async {
                self.questionStore.setQuestionAsPassed(question: self.question)
            }
            level.userDidRightAnswer()
        } else {
            soundEngine.play(melodyURL: GTMGameSound.wrongAnswer)
            level.userDidWrongAnswer()
        }
        return isCorrect
    }
    
    func userDidSwap() {
        guard !isGameOnPause else {
            return
        }
        gameState.didSwap()
        level.userDidSwap()
        setQuestion()
    }
    
    func totalLives() -> Int {
        return level.totalLives()
    }
    
    func totalAnswers() -> Int {
        return level.totalAnswers()
    }
    
    func swapsTotal() -> Int {
        return level.swapsTotal()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dainit - GTMGameModel")
    }
}

extension GTMGameModel: GTMGameStateManagerDelegate {
    func setUIFor(state: GTMGameState) {
        switch state {
        case .initing: return
        case .preparing:
            self.delegate?.startStopSpin(false)
            self.delegate?.updateUI(level.getSwaps(), level.getLife(), level.getNumberOfAnswers())
        case .listening:
            self.delegate?.startStopSpin(true)
        case .prepareCountdown: return
        case .countdown:
            self.delegate?.startStopSpin(true)
        case .stop:
            self.delegate?.startStopSpin(false)
        case .timeIsOver:
            self.delegate?.timeIsOver()
        case .didAnswer, .didSwap: return
        }
    }
    
    func setTime(time: String) {
        self.delegate?.updateTime(time)
    }
    
    func startStopLoading(isLoading: Bool) {
        self.delegate?.startStopLoading(isLoading)
    }
}
