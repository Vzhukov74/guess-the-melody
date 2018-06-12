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

private let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //init SwiftyBeaver
        let console = ConsoleDestination()
        log.addDestination(console)
        
        GTMDatabaseLoader.loadQuestions()
        GTMDatabaseLoader.loadLevels()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MainNavigationController.storyboardInstance
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        //setStatusBarBackgroundColor()
        //UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
    
//    private func setStatusBarBackgroundColor() {
//        OperationQueue.main.addOperation {
//            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//            statusBar.backgroundColor = Colors.alertBackground
//        }
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        GTMCoreDataManager.shared.saveContext()
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
}
