//
//  SidebarView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack {
            Color.sacroBosco
            List(selection: $stateManager.selectedSideBarItem) {
                Section("Apps") {
                    ForEach(dataManager.apps, id: \.id) { app in
                        Text(app.title)
                            .tag(SelectionState.Section(app.title))
                            .padding()
                    }
                }
            }
        }.foregroundColor(Color.sweetVenom)
    }
}

#Preview {
    SidebarView()
        .environmentObject(NavigationStateManager())
        .environmentObject(DataManager())
}
