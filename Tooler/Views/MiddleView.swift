//
//  MiddleView.swift
//  Tooler
//
//  Created by akash kahalkar on 30/12/23.
//

import SwiftUI

struct MiddleView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        List(selection: $stateManager.selectedContenItem) {
            if case let .section(name) = stateManager.selectedSideBarItem {
                Text(name).tag(SelectionState.section(name))
                
            } else {
                Text("no state selected")
            }
        }
    }
}

#Preview {
    MiddleView()
}
