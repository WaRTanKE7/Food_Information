//
//  Food_InformationApp.swift
//  Food_Information
//
//  Created by E7 on 2022/5/24.
//

import SwiftUI

@main
struct Food_InformationApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App 開啟")
            case .inactive:
                print("App 休眠")
            case .background:
                print("App 進入背景")
            @unknown default:
                print("default")
            }
        }
    }
}
