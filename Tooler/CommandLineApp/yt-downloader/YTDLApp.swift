//
//  YTDLApp.swift
//  Tooler
//
//  Created by akash kahalkar on 06/01/24.
//

import Foundation
import SwiftUI

class YTDLApp: CommandLineApp {

    var baseCommand: String = "yt-dlp"
    public static let shared = YTDLApp()
    private let viewModel = YtDownloaderViewModel()
    private let shellController = DefaultShellController()
    
    private init() {
        validate()
    }
    
    func validate() {
        Task {
            guard await shellController.checkIfPresent(command: baseCommand) else {
                fatalError("Commad line app not installed. \(baseCommand)")
            }
            return
        }
    }
    
    var id: String = UUID().uuidString
    var title = " Youtube downloader"
    
    func getContentModels() -> [ContentModel] {
        return [
            ContentModel(title: "Download View", destination: AnyView(DownloadView()))
        ]
    }
}
