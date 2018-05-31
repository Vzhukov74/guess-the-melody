//
//  GTMQuestionsManager.swift
//  guess the melody
//
//  Created by Maximal Mac on 31.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import CoreData
import SwiftyBeaver

class GTMQuestionsManager {
    
    private var _questions = [GTMQuestionCD]()
    private var _currentIndex = 0
    
    init() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GTMQuestionCD")
        let sortDescriptor = NSSortDescriptor(key: "isPassed", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "%K == %@", "isPassed", "false")
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: GTMCoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            self._questions = fetchedResultsController.fetchedObjects as? [GTMQuestionCD] ?? [GTMQuestionCD]()
            SwiftyBeaver.debug("number of questions is \(_questions.count)")
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
    
    func getQuestion() -> GTMQuestionCD? {
        if _currentIndex < _questions.count {
            let question = _questions[_currentIndex]
            _currentIndex += 1
            return question
        } else {
            return nil
        }
    }
    
    func setQuestionAsPassed(question: GTMQuestionCD) {
        question.isPassed = true
    }
}
