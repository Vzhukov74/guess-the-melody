//
//  GTMLevelsManager.swift
//  guess the melody
//
//  Created by Maximal Mac on 31.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import CoreData
import SwiftyBeaver

class GTMLevelsManager {
    static let shared = GTMLevelsManager()
    
    var levels = [GTMLevelCD]()
    
    private init() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GTMLevelCD")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: GTMCoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            self.levels = fetchedResultsController.fetchedObjects as? [GTMLevelCD] ?? [GTMLevelCD]()
            SwiftyBeaver.debug("number of levels is \(levels.count)")
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
    
    func getNextLevelFor(level: GTMLevelCD) -> GTMLevelCD? {
        let index: Int = Int(level.id)
        if index < levels.count {
            return levels[index]
        } else {
            return nil
        }
    }
    
    func setLevelAsPassed(level: GTMLevelCD) {
        level.isPassed = true
        
        let nextLevelId = Int(level.id) + 1
        if nextLevelId <= levels.count {
            levels[nextLevelId - 1].isOpen = true
        }
        GTMCoreDataManager.shared.saveContext()
    }
    
    func score() -> Int {
        var score = 0
        for level in levels where level.isPassed {
            score += Int(level.levelStat?.score ?? 0)
        }
        return score
    }
    
    func progress() -> Float {
        var progress: Float = 0
        var passedLevels: Float = 0
        
        for level in levels where level.isPassed {
            passedLevels += 1
        }
        
        progress = passedLevels / Float(levels.count)
        
        return progress
    }
}
