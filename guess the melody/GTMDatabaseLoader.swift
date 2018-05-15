//
//  GTMDatabaseLoader.swift
//  guess the melody
//
//  Created by Vlad on 14.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import SwiftyBeaver
import CoreData

class GTMDatabaseLoader {
    
    private static let firstStartKeyQuestions = "md.vz.firstStartKey.questions"
    private static let firstStartKeyLevels = "md.vz.firstStartKey.levelss"
    
    class func loadQuestions() {
        if UserDefaults.standard.object(forKey: GTMDatabaseLoader.firstStartKeyQuestions) != nil {
            return
        } else {
            SwiftyBeaver.debug("it is first start")
            UserDefaults.standard.set(true, forKey: GTMDatabaseLoader.firstStartKeyQuestions)
        }
        
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
                GTMDatabaseLoader.saveInDB(questions: questions)
            } else {
               SwiftyBeaver.error("did't parse questions json file")
            }
        } else {
            SwiftyBeaver.error("did't load questions json file")
        }
    }
    
    class func loadLevels() {
        if UserDefaults.standard.object(forKey: GTMDatabaseLoader.firstStartKeyLevels) != nil {
            return
        } else {
            SwiftyBeaver.debug("it is first start")
            UserDefaults.standard.set(true, forKey: GTMDatabaseLoader.firstStartKeyLevels)
        }
        
        if let levelsJson = GTMStaticDataStore.getLevels() {
            if let items = levelsJson["levels"] as? [AnyObject] {
                var index = 0
                var levels = [GTMCameLevel]()
                for itme in items {
                    if let data = itme as? [String: AnyObject] {
                        let level = GTMCameLevel()
                        level.setData(data: data)
                        
                        if index > 2 {
                            level.isOpen = false
                        }
                        index += 1
                        levels.append(level)
                    }
                }
                GTMDatabaseLoader.saveInDB(levels: levels)
            } else {
                SwiftyBeaver.error("did't parse questions json file")
            }
        } else {
            SwiftyBeaver.error("did't load levels json file")
        }
    }
    
    private class func saveInDB(questions: [GTMQuestion]) {
        let coordinator = GTMCoreDataManager.shared.persistentStoreCoordinator
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        var _questions = [GTMQuestionCD]()
        
        autoreleasepool {
            for question in questions {
                let url = question.rightAnswer!.songUrl
                
                let answer1 = GTMAnswerCD(within: context)
                answer1.author = question.rightAnswer!.author
                answer1.songName = question.rightAnswer!.songName
                answer1.albumImageUrl = question.rightAnswer!.albumImageUrl
                answer1.songUrl = question.rightAnswer!.songUrl
                
                let answer2 = GTMAnswerCD(within: context)
                answer2.author = question.wrongAnswers[0].author
                answer2.songName = question.wrongAnswers[0].songName
                answer2.albumImageUrl = question.wrongAnswers[0].albumImageUrl
                answer2.songUrl = question.wrongAnswers[0].songUrl
                
                let answer3 = GTMAnswerCD(within: context)
                answer3.author = question.wrongAnswers[1].author
                answer3.songName = question.wrongAnswers[1].songName
                answer3.albumImageUrl = question.wrongAnswers[1].albumImageUrl
                answer3.songUrl = question.wrongAnswers[1].songUrl
                
                let answer4 = GTMAnswerCD(within: context)
                answer4.author = question.wrongAnswers[2].author
                answer4.songName = question.wrongAnswers[2].songName
                answer4.albumImageUrl = question.wrongAnswers[2].albumImageUrl
                answer4.songUrl = question.wrongAnswers[2].songUrl
                
                let question = GTMQuestionCD(within: context)
                question.url = url
                question.isPassed = false
                question.rightAnswer = answer1
                question.addToWrongAnswers([answer2, answer3, answer4])
                
                _questions.append(question)
            }
        }
        
        do {
            try context.save()
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
    
    private class func saveInDB(levels: [GTMCameLevel]) {
        let coordinator = GTMCoreDataManager.shared.persistentStoreCoordinator
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        var _levels = [GTMLevelCD]()
        
        autoreleasepool {
            for level in levels {
                let _level = GTMLevelCD(within: context)
                _level.map(from: level)
                
                if level.levelStat != nil {
                    let levelStat = GTMLevelStatCD(within: context)
                    levelStat.numberOfError = Int64(level.levelStat!.numberOfError)
                    levelStat.numberOfSwaps = Int64(level.levelStat!.numberOfSwaps)
                    levelStat.score = Int64(level.levelStat!.score)
                    levelStat.stars = Int64(level.levelStat!.stars)
                    _level.levelStat = levelStat
                }
                _levels.append(_level)
            }
        }
        
        do {
            try context.save()
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
}
