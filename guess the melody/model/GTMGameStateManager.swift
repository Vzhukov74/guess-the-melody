//
//  GTMGameStateManager.swift
//  guess the melody
//
//  Created by Maximal Mac on 09.06.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

protocol GTMGameStateManagerDelegate: class {
    func setUIFor(state: GTMGameState)
    func setTime(time: String)
    func startStopLoading(isLoading: Bool)
}

class GTMGameStateManager {
    private var timer: GTMTimer?
    private let countdownPlayer = GTMGameSoundEngine()
    private let player = GTMPlayer()
    private let songTime: Int
    
    private var previousState: GTMGameState = .initing
    private var state: GTMGameState = .initing {
        didSet {
            switch state {
            case .initing: return
            case .preparing:
                self.timer?.pause()
                countdownPlayer.stop()
                
                self.delegate?.setUIFor(state: .preparing)
                self.delegate?.setTime(time: GTMTimerFormatter.timeAsStringFor(time: Double(songTime)))
                
                timer = GTMTimer(time: songTime)
                timer?.updateTime = { [weak self] (time) in
                    DispatchQueue.main.async {
                        self?.delegate?.setTime(time: time)
                    }
                }
                timer?.timeIsOver = { [weak self] in
                    DispatchQueue.main.async {
                        self?.state = .prepareCountdown
                    }
                }
            case .listening:
                self.delegate?.setUIFor(state: .listening)
                player.start()
                timer?.toggle()
            case .prepareCountdown:
                player.stop()
                timer = GTMTimer(time: 3)
                self.delegate?.setTime(time: GTMTimerFormatter.timeAsStringFor(time: 3))
                timer?.updateTime = { (time) in
                    DispatchQueue.main.async {
                        self.delegate?.setTime(time: time)
                    }
                }
                timer?.timeIsOver = { [weak self] in
                    DispatchQueue.main.async {
                        self?.setNew(state: .timeIsOver)
                    }
                }
                self.setNew(state: .countdown)
            case .countdown:
                countdownPlayer.play(melodyURL: GTMGameSound.countdown)
                self.delegate?.setUIFor(state: .countdown)
                timer?.toggle()
            case .stop:
                self.delegate?.setUIFor(state: .stop)
                player.stop()
                timer?.pause()
            case .timeIsOver:
                self.delegate?.setUIFor(state: .timeIsOver)
            case .didAnswer, .didSwap:
                player.stop()
                countdownPlayer.stop()
                timer = nil
            }
        }
    }
    
    weak var delegate: GTMGameStateManagerDelegate?
    
    init(songTime: Int) {
        self.songTime = songTime
    }
    
    private func setNew(state: GTMGameState) {
        self.state = state
    }
    
    func currentState() -> GTMGameState {
        return self.state
    }
    
    func reset() {
        self.state = .initing
    }
    
    func setSongBy(url: String) {
        player.delegate = self
        player.setSongBy(urlStr: url)
        self.setNew(state: .preparing)
    }
    
    func stopGame() {
        previousState = state
        setNew(state: .stop)
    }
    
    func continueGame() {
        setNew(state: previousState)
    }
    
    func didAnswer() {
        setNew(state: .didAnswer)
    }
    
    func didSwap() {
        setNew(state: .didSwap)
    }
}

extension GTMGameStateManager: GTMPlayerDelegate {
    func startLoad() {
        self.delegate?.startStopLoading(isLoading: true)
    }
    
    func endLoad() {
        self.delegate?.startStopLoading(isLoading: false)
        self.setNew(state: .listening)
    }
    
    func error() {
        print("player load with error")
    }
}
