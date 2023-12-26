//
//  ToolerApp.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

@main
struct ToolerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        Settings {
            SettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
