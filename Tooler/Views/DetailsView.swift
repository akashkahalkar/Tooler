//
//  DetailsView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        if case let .Section(name) = $stateManager.selectedContenItem.wrappedValue {
            Text(name)
        } else {
            Text("EmptyView")
        }
    }
}

#Preview {
    DetailsView()
        .environmentObject(NavigationStateManager())
        .environmentObject(DataManager())
}
