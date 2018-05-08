//
//  GTMQuestionCD+CoreDataProperties.swift
//  
//
//  Created by Vlad on 08.05.2018.
//
//

import Foundation
import CoreData


extension GTMQuestionCD: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GTMQuestionCD> {
        return NSFetchRequest<GTMQuestionCD>(entityName: "GTMQuestionCD")
    }

    @NSManaged public var isPassed: Bool
    @NSManaged public var url: String?
    @NSManaged public var rightAnswer: GTMAnswerCD?
    @NSManaged public var wrongAnswers: NSSet?

}

// MARK: Generated accessors for wrongAnswers
extension GTMQuestionCD {

    @objc(addWrongAnswersObject:)
    @NSManaged public func addToWrongAnswers(_ value: GTMAnswerCD)

    @objc(removeWrongAnswersObject:)
    @NSManaged public func removeFromWrongAnswers(_ value: GTMAnswerCD)

    @objc(addWrongAnswers:)
    @NSManaged public func addToWrongAnswers(_ values: NSSet)

    @objc(removeWrongAnswers:)
    @NSManaged public func removeFromWrongAnswers(_ values: NSSet)

}
