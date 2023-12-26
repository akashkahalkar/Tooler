//
//  NavigationStateManager.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import Foundation

struct CommandLineApp: Hashable, Codable {
    var name: String
}

enum SelectionState: Hashable, Codable {
    case AppSection(CommandLineApp)
    case Settings
}

class NavigationStateManager: ObservableObject {
    
    @Published var selectionState: SelectionState? = nil
    
    
}
