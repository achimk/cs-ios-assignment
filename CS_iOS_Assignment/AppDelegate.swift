//
//  AppDelegate.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppConfiguration.setup()
        let viewController = MoviesHomeModuleFactory.make()
        
        window = UIWindow()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

