//
//  GameViewController.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    private var isAlbumImageActive = false
    
    @IBAction func flipAction() {
        isAlbumImageActive = !isAlbumImageActive
        flip()
    }
    
    var model: GTMGameModel!
    
    var qManager = GTMQuestionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        model.setUIForQuestion = { [weak self] in
            self?.setQuestion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSpin()
        self.setQuestion()
    }
    
    @objc private func useDidAnswer(index: Int) {
        flipAction()
        model.userDidAnswer(index: index)
    }
    
    @objc private func useDidSwap() {
        model.userDidSwap()
    }
    
    @objc private func closeButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func playAndPauseButtonAction() {
        
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

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}

