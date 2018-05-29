//
//  LevelEndViewController.swift
//  guess the melody
//
//  Created by Maximal Mac on 29.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

enum GTMLevelEndActions {
    case goToMenu
    case palyAgain
    case goToNextLevel
}

class LevelEndViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playAgainOrNext: UIButton! {
        didSet {
            playAgainOrNext.addTarget(self, action: #selector(self.playAgainOrNextAction), for: .touchUpInside)
        }
    }
    @IBOutlet weak var goToMenu: UIButton! {
        didSet {
            goToMenu.addTarget(self, action: #selector(self.goToMenuAction), for: .touchUpInside)
        }
    }
    
    
    var isUserWin: Bool!
    var result: GTMLevelStat?
    var completion: ((_ action: GTMLevelEndActions) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.gradientStart
        
        goToMenu.setTitle("Go to Menu!", for: .normal)
        
        if isUserWin {
            configureAsWinVC()
        } else {
            configureAsLoseVC()
        }
    }
    
    private func configureAsWinVC() {
        playAgainOrNext.setTitle("Go to Next Level!", for: .normal)
    }
    
    private func configureAsLoseVC() {
        playAgainOrNext.setTitle("Play Again", for: .normal)
    }
    
    private func clouse(with action: GTMLevelEndActions) {
        dismiss(animated: true) { [weak self] in
            self?.completion?(action)
        }
    }

    deinit {
        print("deinit - LavelEndViewController")
    }
}

extension LevelEndViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .levelEnd
}

@objc extension LevelEndViewController {
    private func playAgainOrNextAction() {
        if isUserWin {
            clouse(with: .goToNextLevel)
        } else {
            clouse(with: .palyAgain)
        }
    }
    
    private func goToMenuAction() {
        clouse(with: .goToMenu)
    }
}
