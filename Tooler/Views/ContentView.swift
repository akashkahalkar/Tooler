//
//  ContentView.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var stateManager = NavigationStateManager()
    @StateObject var dataManager = DataManager()
    
    var body: some View {
        
        NavigationSplitView {
            List(selection: $stateManager.selectedSideBarItem) {
                ForEach(dataManager.apps, id: \.id) { app in
                    getSideBarItemListView(app.title)
                }
            }
        } content: {
            switch stateManager.selectedSideBarItem {
            case .Section(let sectionName):
                List(selection: $stateManager.selectedContenItem) {
                    if let contents = dataManager.apps.first(where: { $0.title == sectionName })?.getContentModels() {
                        ForEach(contents, id: \.id) {
                            getContentItemListView(contentModel: $0)
                        }
                    } else {
                        Text("No Content models provided")
                    }
                }
            case nil:
                Text("NO item selected")
            }
        } detail: {
            switch stateManager.selectedContenItem {
            case .Section(_):
                if let detailView = stateManager.activeContentModel?.destination {
                    detailView
                } else {
                    Text("No Details View provided")
                }
            case nil:
                Text("NO item selected")
            }
            //DetailsView()
        }
        .background(Color.plumCheese)
        .environmentObject(stateManager)
        .environmentObject(dataManager)
        .onAppear {
            if let app = dataManager.apps.first {
                stateManager.selectedSideBarItem = SelectionState.Section(app.title)
            }
        }
    }

    private func getSideBarItemListView(_ sectionName: String) -> some View {
        return Text(sectionName)
            .tag(SelectionState.Section(sectionName))
            .padding()
            .onTapGesture {
                stateManager.updateSideBar(sectionName: sectionName)
            }
    }
    
    private func getContentItemListView(contentModel: ContentModel) -> some View {
        return Button {
            stateManager.updateContenList(contentModel: contentModel)
        } label: {
            Text(contentModel.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }.tag(SelectionState.Section(contentModel.title))
    }
}

#Preview {
    ContentView()
}

