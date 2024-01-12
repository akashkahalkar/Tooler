//
//  NavigationStateManager.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import Foundation
import SwiftUI

enum SelectionState: Hashable, Codable {
    case Section(String)
}

class NavigationStateManager: ObservableObject {
    @Published var selectedSideBarItem: SelectionState? = nil
    @Published var selectedContenItem: SelectionState? = nil
    @Published var activeContentModel: ContentModel? = nil
    
    func updateSideBar(sectionName: String) {
        if case let .Section(name) = selectedSideBarItem, name != sectionName {
            selectedContenItem = nil
            activeContentModel = nil
        }
        selectedSideBarItem = SelectionState.Section(sectionName)
    }
    
    func updateContenList(contentModel: ContentModel) {
        DispatchQueue.main.async {
            self.activeContentModel = contentModel
            self.selectedContenItem = SelectionState.Section(contentModel.title)
        }
    }
}
