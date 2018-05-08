//
//  GTMLevelCD+CoreDataProperties.swift
//  
//
//  Created by Vlad on 08.05.2018.
//
//

import Foundation
import CoreData


extension GTMLevelCD: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GTMLevelCD> {
        return NSFetchRequest<GTMLevelCD>(entityName: "GTMLevelCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isOpen: Bool
    @NSManaged public var isPassed: Bool
    @NSManaged public var life: Int64
    @NSManaged public var numberOfAnswers: Int64
    @NSManaged public var numberOfQuestions: Int64
    @NSManaged public var swaps: Int64
    @NSManaged public var timeToAnswer: Int64
    @NSManaged public var levelStat: GTMLevelStatCD?

}
