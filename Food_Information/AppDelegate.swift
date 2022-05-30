//
//  AppDelegate.swift
//  Food_Information
//
//  Created by E7 on 2022/5/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let userDefault = UserDefaults()
        if userDefault.value(forKey: "googleApiKey") == nil {
            userDefault.set("AIzaSyDE7nox5SExezUjPkieX7PZxvL8St-2U40", forKey: "googleApiKey")
        }
        
        return true
    }
}
