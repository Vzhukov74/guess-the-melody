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
            albumImageView.makeCurcular(CGRect(x: 0, y: 0, width: 160, height: 160))
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
    
    @IBOutlet weak var activityView: NVActivityIndicatorView! {
        didSet {
            activityView.type = .audioEqualizer
        }
    }
    
    private var isAlbumImageActive = false
    
    @IBAction func flipAction() {
        isAlbumImageActive = !isAlbumImageActive
        flip()
    }
    
    private let rightAnswerView = RightAnswerView()
    private var rightAnswerViewBottomConstrain = NSLayoutConstraint()
    
    var model: GTMGameModel!
    
    let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .lineScale, color: UIColor.red, padding: 1)
    
    private func setupRightAnswerView() {
        self.view.addSubview(rightAnswerView)
        rightAnswerView.translatesAutoresizingMaskIntoConstraints = false
        
        rightAnswerViewBottomConstrain = rightAnswerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([rightAnswerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8), rightAnswerView.heightAnchor.constraint(equalToConstant: 200),rightAnswerViewBottomConstrain , rightAnswerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1)])
        
        rightAnswerView.backgroundColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightAnswerView()
        rightAnswerView.nextAction = { [weak self] in
            self?.model.setNextQuestion()
            self?.hideRightAnswerView()
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
        model.setNextQuestion()
        
        self.view.addSubview(activity)
        activity.startAnimating()
        //activityView.startAnimating()
    }
    
    private func setLife(life: Int) {
        SwiftyBeaver.info(life)
    }
    
    private func setRightAnswers(rightAnswers: Int) {
        SwiftyBeaver.info(rightAnswers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSpin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.startGame()
    }
    
    private func setQuestion() {
        let url = model.imageURLForQuestion()
        albumImageView.sd_setImage(with: url, completed: nil)

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
    
    private func flip() {
        if isAlbumImageActive {
            UIView.transition(from: self.musicPlateView, to: self.albumImageView, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: self.albumImageView, to: self.musicPlateView, duration: 0.5, options: [.transitionFlipFromLeft,. showHideTransitionViews], completion: nil)
        }
    }

    deinit {
        print("deinit - GameViewController")
    }
}

@objc extension GameViewController {
    private func useDidAnswer(index: Int) {
        //flipAction()
        let isCorrect = model.userDidAnswer(index: index)
        if isCorrect {
            showRightAnswerView()
        } else {
            
        }
    }
    
    private func useDidSwap() {
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
}

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}

