//
//  GameViewController.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyBeaver

class GameViewController: UIViewController {

    @IBOutlet weak var musicPlateView: MusicPlateView! {
        didSet {
            musicPlateView.layer.cornerRadius = musicPlateView.bounds.width / 2
            musicPlateView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var musicPlateAlbumViewsContainer: UIView!
    @IBOutlet weak var albumImageView: AlbumImageView! {
        didSet {            
            //albumImageView.makeCurcular(CGRect(x: 0, y: 0, width: 160, height: 160))
        }
    }
    
    @IBOutlet weak var answersView: AnswersView!
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.addTarget(self, action: #selector(self.closeButtonAction), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var playAndPauseButton: UIButton! {
        didSet {
            playAndPauseButton.addTarget(self, action: #selector(self.playAndPauseButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!

    
    private let rightAnswerView = RightAnswerView()
    private var rightAnswerViewBottomConstrain = NSLayoutConstraint()
    
    private let wrongAnswerView = WrongAnswerView()
    private var wrongAnswerViewBottomConstrain = NSLayoutConstraint()
    
    var model: GTMGameModel!
    
    private let activity = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 10, y: 30, width: 20, height: 20), type: .lineScale, color: UIColor.red, padding: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.color = UIColor.white
        
        setupRightAnswerView()
        rightAnswerView.nextAction = { [weak self] in
            self?.model.setNextQuestion()
            self?.hideRightAnswerView()
        }
        
        setupWrongAnswerView()
        wrongAnswerView.nextAction = { [weak self] in
            self?.model.setNextQuestion()
            self?.hideWrongAnswerView()
        }
        
        model.updateTime = { [weak self] (time) in
            DispatchQueue.main.async {
                self?.timeLabel.text = time
            }
        }
        
        answersView.userDidAnswer = { [weak self] (index) in
            self?.useDidAnswer(index: index)
        }
        
        answersView.userDidSwap = { [weak self] in
            self?.useDidSwap()
        }
        
        model.updateUI = { [weak self] (swap, life, rightAnswers) in
            self?.answersView.configureSwapButton(swap: swap)
            self?.setLife(life: life)
            self?.setRightAnswers(rightAnswers: rightAnswers)
            
            self?.setQuestion()
        }
        
        model.startStopLoading = { [weak self] (isLoading) in
            if isLoading {
                self?.activity.startAnimating()
                self?.activity.isHidden = false
            } else {
                self?.activity.stopAnimating()
                self?.activity.isHidden = true
                self?.startSpin()
            }
        }
        
        model.timeIsOver = { [weak self] in
            self?.showWrongAnswerView()
        }
        
        model.setNextQuestion()
        
        self.view.addSubview(activity)
    }
    
    private func setupRightAnswerView() {
        self.view.addSubview(rightAnswerView)
        rightAnswerView.translatesAutoresizingMaskIntoConstraints = false
        
        rightAnswerViewBottomConstrain = rightAnswerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([rightAnswerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8), rightAnswerView.heightAnchor.constraint(equalToConstant: 200), rightAnswerViewBottomConstrain, rightAnswerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1)])
    }
    
    private func setupWrongAnswerView() {
        self.view.addSubview(wrongAnswerView)
        wrongAnswerView.translatesAutoresizingMaskIntoConstraints = false
        
        wrongAnswerViewBottomConstrain = wrongAnswerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([wrongAnswerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8), wrongAnswerView.heightAnchor.constraint(equalToConstant: 200), wrongAnswerViewBottomConstrain, wrongAnswerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1)])
    }
    
    private func setLife(life: Int) {
        livesLabel.text = "\(String(life))" + "/" + "\(String(model.totalLives()))"
    }
    
    private func setRightAnswers(rightAnswers: Int) {
        answersLabel.text = "\(String(rightAnswers))" + "/" + "\(String(model.totalAnswers()))"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.stopGame()
    }
    
    private func setQuestion() {
        var data = [GTMAnswerData]()
        for index in 0..<4 {
            data.append(model.answerFor(index: index))
        }
        answersView.setData(data: data)
    }

    private func startSpin() {
        musicPlateView.startSpin()
    }
    
    private func stopSpin() {
        musicPlateView.stopSpin()
    }
    
    deinit {
        print("deinit - GameViewController")
    }
}

@objc extension GameViewController {
    private func useDidAnswer(index: Int) {
        stopSpin()
        let isCorrect = model.userDidAnswer(index: index)
        if isCorrect {
            showRightAnswerView()
        } else {
            showWrongAnswerView()
        }
    }
    
    private func useDidSwap() {
        stopSpin()
        model.userDidSwap()
    }
    
    private func closeButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func playAndPauseButtonAction() {
        
    }
}

extension GameViewController {
    private func showRightAnswerView() {
        UIView.animate(withDuration: 0.3) {
            self.rightAnswerViewBottomConstrain.constant = -4
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideRightAnswerView() {
        UIView.animate(withDuration: 0.3) {
            self.rightAnswerViewBottomConstrain.constant = 200
            self.view.layoutIfNeeded()
        }
    }
    
    private func showWrongAnswerView() {
        UIView.animate(withDuration: 0.3) {
            self.wrongAnswerViewBottomConstrain.constant = -4
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideWrongAnswerView() {
        UIView.animate(withDuration: 0.3) {
            self.wrongAnswerViewBottomConstrain.constant = 200
            self.view.layoutIfNeeded()
        }
    }
}

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}

