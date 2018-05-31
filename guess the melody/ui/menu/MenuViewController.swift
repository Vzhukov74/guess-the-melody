//
//  MenuViewController.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            LevelCell.register(table: tableView)
        }
    }
    
    var model: GTMMenuModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.background
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LevelCell.cell(table: tableView, indexPath: indexPath)
        let level = model.levels[indexPath.row]
        cell.configure(level: level)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let level = model.levels[indexPath.row]
        if level.isOpen && !level.isPassed {
            if let vc = GameViewController.storyboardInstance {
                vc.model = GTMGameModel(level: GTMGameLevelManager(level: level))
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if !level.isOpen {
                showAlertWith(message: "Level is locked, you must pass previous levels!")
            } else if level.isPassed {
                showAlertWith(message: "Level is passed. You can pass level only once!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }
}

extension MenuViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .menu
}
