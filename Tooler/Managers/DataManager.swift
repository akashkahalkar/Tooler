//
//  DataManager.swift
//  Tooler
//
//  Created by akash kahalkar on 26/12/23.
//

import Foundation
import SwiftUI

protocol AppViewManager {
    func getContentModels() -> [ContentModel]
}

protocol CommandLineApp: AppViewManager, Identifiable {
    var id: String { get }
    var title: String { get set }
}

public struct ContentModel: Identifiable {
    static func == (lhs: ContentModel, rhs: ContentModel) -> Bool {
        return lhs.title == rhs.title
    }

    public var id: String = UUID().uuidString
    public var title: String
    public var destination: AnyView?
}

final class DataManager: ObservableObject {
    let apps: [any CommandLineApp] = [BrewApp.shared]
}
