//
//  GTMLevelStatCD+CoreDataProperties.swift
//  
//
//  Created by Vlad on 08.05.2018.
//
//

import Foundation
import CoreData

extension GTMLevelStatCD: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GTMLevelStatCD> {
        return NSFetchRequest<GTMLevelStatCD>(entityName: "GTMLevelStatCD")
    }

    @NSManaged public var numberOfError: Int64
    @NSManaged public var numberOfSwaps: Int64
    @NSManaged public var score: Int64
    @NSManaged public var stars: Int64
    @NSManaged public var level: GTMLevelCD?

}
