//
//  GTMAnswerCD+CoreDataProperties.swift
//  
//
//  Created by Vlad on 08.05.2018.
//
//

import Foundation
import CoreData

extension GTMAnswerCD: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GTMAnswerCD> {
        return NSFetchRequest<GTMAnswerCD>(entityName: "GTMAnswerCD")
    }

    @NSManaged public var albumImageUrl: String?
    @NSManaged public var author: String?
    @NSManaged public var songName: String?
    @NSManaged public var songUrl: String?
    @NSManaged public var question: GTMQuestionCD?
    @NSManaged public var question_: GTMQuestionCD?

}
