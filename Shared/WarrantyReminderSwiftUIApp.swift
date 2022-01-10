//
//  WarrantyReminderSwiftUIApp.swift
//  Shared
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI

@main
struct WarrantyReminderSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
