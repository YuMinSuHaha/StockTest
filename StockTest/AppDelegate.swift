//
//  AppDelegate.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var timer: Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let timeStr = UserDefaults.standard.string(forKey: "update_time")
        let time = (timeStr?.doubleValueBut ?? 10) / 1000
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (_) in
            FakeAPI.shared.goRandom()
        })
        UserDefaults.standard.setValue(true, forKey: "animation_open")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        timer?.invalidate()
        timer = nil
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let timeStr = UserDefaults.standard.string(forKey: "update_time")
        let time = (timeStr?.doubleValueBut ?? 10) / 1000
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (_) in
            FakeAPI.shared.goRandom()
        })
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    

}

