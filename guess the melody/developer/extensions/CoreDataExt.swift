//
//  CoreDataExt.swift
//  guess the melody
//
//  Created by Vlad on 08.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import CoreData

protocol EntityCreating {
    init(within context: NSManagedObjectContext)
}

extension EntityCreating where Self: NSManagedObject {
    init(within context: NSManagedObjectContext = GTMCoreDataManager.shared.managedObjectContext) {
        self = NSEntityDescription.insertNewObject(forEntityName: "\(Self.self)", into: context) as! Self
    }
}
