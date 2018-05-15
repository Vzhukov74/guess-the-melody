//
//  MainNavigationController.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let vc = MenuViewController.storyboardInstance {
            vc.model = GTMMenuModel()
            self.viewControllers = [vc]
        }
    }
}

extension MainNavigationController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .main
}

