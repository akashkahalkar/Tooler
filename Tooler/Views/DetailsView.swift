//
//  DetailsView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    
    var body: some View {
        switch stateManager.selectionState {
        case .AppSection(let app):
            Text("Show app \(app.name)")
        case .Settings:
            SettingsView()
        case .none:
            Text("No Selection")
        }
    }
}

#Preview {
    DetailsView().environmentObject(NavigationStateManager())
}
