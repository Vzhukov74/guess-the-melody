//
//  GTMMenuModel.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import CoreData
import SwiftyBeaver

class GTMLevelsHelper {
    static let shared = GTMLevelsHelper()
    
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
        let index: Int = Int(level.id) - 1
        return levels[index]
    }
}

class GTMMenuModel {
    var levels: [GTMLevelCD] {
        get {
            return GTMLevelsHelper.shared.levels
        }
    }
}
