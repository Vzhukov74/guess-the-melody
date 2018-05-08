//
//  StoryboardList.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

import UIKit

enum StoryboardList: String {
    case main = "MainNavigationController"
    case menu = "MenuViewController"
    case game = "GameViewController"
}

protocol StoryboardInstanceable {
    static var storyboardName: StoryboardList {get set}
}

extension StoryboardInstanceable {
    static var storyboardInstance: Self? {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:String(describing: self)) as? Self
        return vc
    }
}
