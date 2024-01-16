//
//  BrewApp.swift
//  Tooler
//
//  Created by akash kahalkar on 04/01/24.
//

import Foundation
import SwiftUI

final class BrewApp: CommandLineApp {
    var id: String = UUID().uuidString
    var title: String = "Brew"
    var viewModel: BrewManagerViewModel
    public static let shared = BrewApp()

    private init() {
        let shellController = DefaultShellController()
        viewModel = BrewManagerViewModel(shellController: shellController)
    }

    func getContentModels() -> [ContentModel] {
        let installView = BrewManagerView(viewModel: viewModel)
        let uninstallView = BrewPackageList(viewModel: viewModel)
        return [
            ContentModel(title: "Install View", destination: AnyView(installView)),
            ContentModel(title: "Uninstall Viewx", destination: AnyView(uninstallView)),
        ]
    }
}
