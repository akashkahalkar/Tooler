//
//  NavigationStateManager.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import Foundation
import SwiftUI

enum SelectionState: Hashable, Codable {
    case section(String)
}

class NavigationStateManager: ObservableObject {
    @Published var selectedSideBarItem: SelectionState? = nil
    @Published var selectedContenItem: SelectionState? = nil
    @Published var activeContentModel: ContentModel? = nil

    func updateSideBar(sectionName: String) {
        if case let .section(name) = selectedSideBarItem,
           name != sectionName,
           selectedContenItem != nil
        {
            selectedContenItem = nil
        }
        selectedSideBarItem = SelectionState.section(sectionName)
    }

    func updateContenList(contentModel: ContentModel) {
        DispatchQueue.main.async {
            self.activeContentModel = contentModel
            self.selectedContenItem = SelectionState.section(contentModel.title)
        }
    }
}
