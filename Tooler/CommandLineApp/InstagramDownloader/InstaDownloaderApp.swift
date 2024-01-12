//
//  InstaDownloaderApp.swift
//  Tooler
//
//  Created by akash kahalkar on 08/01/24.
//

import Foundation
import SwiftUI

final class InstaDownloaderApp {
    
    public static let shared: InstaDownloaderApp = InstaDownloaderApp()
    private var viewModel: InstaLoaderViewModel
    private let shellProvider: ShellProvider
    
    private init() {
        self.shellProvider = DefaultShellController()
        self.viewModel = InstaLoaderViewModel(shellController: self.shellProvider)
    }
}

extension InstaDownloaderApp: CommandLineApp {
    var title: String {
        return "Insta Downloader"
    }
    
    var id: String {
        UUID().uuidString
    }
    
    var baseCommand: String {
        return "instaloader"
    }
    
    func getContentModels() -> [ContentModel] {
        return [
            ContentModel(
                title: "DownloadView",
                destination: AnyView(InstaDownloaderView(viewModel: viewModel))
            )
        ]
    }
}
