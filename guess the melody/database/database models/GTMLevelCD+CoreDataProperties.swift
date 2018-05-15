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

    func map(from: GTMCameLevel) {
        id = Int64(from.id)
        isOpen = from.isOpen
        isPassed = from.isPassed
        life = Int64(from.life)
        numberOfAnswers = Int64(from.numberOfAnswers)
        numberOfQuestions = Int64(from.numberOfQuestions)
        swaps = Int64(from.swaps)
        timeToAnswer = Int64(from.timeToAnswer)
    }
}
