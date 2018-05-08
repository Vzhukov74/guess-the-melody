//
//  AppDelegate.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit
import CoreData
import SwiftyBeaver

fileprivate let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //init SwiftyBeaver
        let console = ConsoleDestination()
        log.addDestination(console)
        
        loadQuestions()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MainNavigationController.storyboardInstance
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func loadQuestions() {
        if let questionsJson = GTMStaticDataStore.getQuestions() {
            if let items = questionsJson["questions"] as? [AnyObject] {
                var questions = [GTMQuestion]()
                for item in items {
                    if let data = item as? [String : AnyObject] {
                        let question = GTMQuestion()
                        question.setData(data: data)
                        questions.append(question)
                    }
                }
                self.saveInDB(questions: questions)
            } else {
                
            }
        } else {
            
        }
    }
    
    private func saveInDB(questions: [GTMQuestion]) {
//        let coordinator = GTMCoreDataManager.shared.persistentStoreCoordinator
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = coordinator
//        
//        var _questions = [GTMQuestionCD]()
//        
//        autoreleasepool {
//            for question in questions {
//                let url = question.rightAnswer!.songUrl
//
//                let answer1 = GTMAnswerCD(within: context)
//                answer1.author = question.rightAnswer!.author
//                answer1.songName = question.rightAnswer!.songName
//                answer1.albumImageUrl = question.rightAnswer!.albumImageUrl
//                answer1.songUrl = question.rightAnswer!.songUrl
//
//                let answer2 = GTMAnswerCD(within: context)
//                answer2.author = question.wrongAnswers[0].author
//                answer2.songName = question.wrongAnswers[0].songName
//                answer2.albumImageUrl = question.wrongAnswers[0].albumImageUrl
//                answer2.songUrl = question.wrongAnswers[0].songUrl
//
//                let answer3 = GTMAnswerCD(within: context)
//                answer3.author = question.wrongAnswers[1].author
//                answer3.songName = question.wrongAnswers[1].songName
//                answer3.albumImageUrl = question.wrongAnswers[1].albumImageUrl
//                answer3.songUrl = question.wrongAnswers[1].songUrl
//
//                let answer4 = GTMAnswerCD(within: context)
//                answer4.author = question.wrongAnswers[2].author
//                answer4.songName = question.wrongAnswers[2].songName
//                answer4.albumImageUrl = question.wrongAnswers[2].albumImageUrl
//                answer4.songUrl = question.wrongAnswers[2].songUrl
//
//                let question = GTMQuestionCD(within: context)
//                question.url = url
//                question.isPassed = false
//                question.rightAnswer = answer1
//                question.addToWrongAnswers([answer2, answer3, answer4])
//
//                _questions.append(question)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch {
//            SwiftyBeaver.error(error.localizedDescription)
//        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "guess_the_melody")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

