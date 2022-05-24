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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
