//
//  SidebarView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    
    var body: some View {
        List(selection: $stateManager.selectionState) {
            Section("Apps") {
                Text("App 1")
                    .tag(SelectionState.AppSection(
                        CommandLineApp(name: "App 1"))
                    )
                Text("App 2")
                    .tag(SelectionState.AppSection(
                        CommandLineApp(name: "App 2"))
                    )
            }
            Text("Settings")
                .tag(SelectionState.Settings)
        }
    }
}

#Preview {
    SidebarView()
        .environmentObject(NavigationStateManager())
}
