//
//  GTMCoreDataManager.swift
//  guess the melody
//
//  Created by Vlad on 08.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import SwiftyBeaver
import CoreData

class GTMCoreDataManager {
    static let shared = GTMCoreDataManager()
    
    private init() {}
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "guess_the_melody", withExtension: "momd")!
        SwiftyBeaver.debug(modelURL.absoluteString)
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

class GTMQuestionManager {
    
    private var questions = [GTMQuestionCD]()
    private var currentIndex = 0
    
    init() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GTMQuestionCD")
        let sortDescriptor = NSSortDescriptor(key: "isPassed", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //let predicate = NSPredicate(format: "%K == %@", "isPassed", "false")
        //fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: GTMCoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            self.questions = fetchedResultsController.fetchedObjects as? [GTMQuestionCD] ?? [GTMQuestionCD]()
            SwiftyBeaver.debug("number of questions is \(questions.count)")
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
    
    func getQuestion() -> GTMQuestionCD? {
        if currentIndex < questions.count {
            let question = questions[currentIndex]
            currentIndex += 1
            return question
        } else {
            return nil
        }
    }
    
    func setQuestionAsPassed(question: GTMQuestion) {
//        do {
//            let db = try Realm()
//            let songURL = question.rightAnswer?.songUrl ?? "-"
//            let predicate = NSPredicate(format: "url == %@", songURL)
//            if let question = Array(db.objects(Question.self).filter(predicate)).first {
//
//                try db.write {
//                    question.isPassed = true
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}
