//
//  ContentView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var stateManager = NavigationStateManager()
    
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailsView()
        }
        
        .environmentObject(stateManager)
    }
}

#Preview {
    ContentView()
}
