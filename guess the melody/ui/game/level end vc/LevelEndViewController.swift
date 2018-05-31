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
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var starImg1: UIImageView! {
        didSet {
            starImg1.tintColor = Colors.starHidden
        }
    }
    
    @IBOutlet weak var starImg2: UIImageView! {
        didSet {
            starImg2.tintColor = Colors.starHidden
        }
    }
    
    @IBOutlet weak var starImg3: UIImageView! {
        didSet {
            starImg3.tintColor = Colors.starHidden
        }
    }
    
    var isUserWin: Bool!
    var result: GTMLevelStat?
    var completion: ((_ action: GTMLevelEndActions) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.background
        
        goToMenu.setTitle("Go to Menu!", for: .normal)
        
        if isUserWin {
            configureAsWinVC()
        } else {
            configureAsLoseVC()
        }
    }
    
    private func configureAsWinVC() {
        titleImage.image = Images.winUnicorn
        playAgainOrNext.setTitle("Go to Next Level!", for: .normal)
        configureStar(stars: result?.stars ?? 0)
    }
    
    private func configureAsLoseVC() {
        titleImage.image = Images.loseUnicorn
        playAgainOrNext.setTitle("Play Again", for: .normal)
    }
    
    private func clouse(with action: GTMLevelEndActions) {
        dismiss(animated: true) { [weak self] in
            self?.completion?(action)
        }
    }
    
    private func configureStar(stars: Int) {
        switch stars {
        case 0:
            starImg1.tintColor = Colors.starOff
            starImg2.tintColor = Colors.starOff
            starImg3.tintColor = Colors.starOff
        case 1:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOff
            starImg3.tintColor = Colors.starOff
        case 2:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOn
            starImg3.tintColor = Colors.starOff
        case 3:
            starImg1.tintColor = Colors.starOn
            starImg2.tintColor = Colors.starOn
            starImg3.tintColor = Colors.starOn
        default:
            starImg1.tintColor = Colors.starHidden
            starImg2.tintColor = Colors.starHidden
            starImg3.tintColor = Colors.starHidden
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
