//
//  ytDownloaderViewModel.swift
//  Tooler
//
//  Created by akash kahalkar on 08/01/24.
//

import Foundation

final class YtDownloaderViewModel: ObservableObject {
    
    private var shellController: ShellProvider = DefaultShellController()
    
    func download(url: String, destinationPath: String) async -> Bool {
        
        let commandValidationValid = await shellController.checkIfPresent(command: "yt-dlp")
        print("commandValidationValid", commandValidationValid)
        let commandValidationinValid = await shellController.checkIfPresent(command: "WTF")
        print("commandValidationinValid", commandValidationinValid)
        
        print("destination", destinationPath)
        print("url", url)
        let formatParam = "-f \"bestvideo[height<=1080][vcodec^=avc][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best\""
        let downloadCommand = "yt-dlp \(formatParam) -P \(destinationPath) \"\(url)\""
        let result = await shellController.safeShell(downloadCommand, liveOutput: nil)
        
        print(result.output ?? "empty output")
        
        return result.status == 0
        
    }
}
