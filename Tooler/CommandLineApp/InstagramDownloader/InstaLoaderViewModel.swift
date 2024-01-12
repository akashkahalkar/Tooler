//
//  InstaLoaderViewModel.swift
//  Tooler
//
//  Created by akash kahalkar on 08/01/24.
//

import Foundation
import SwiftUI

final class InstaLoaderViewModel {
    
    private var shellController: ShellProvider
    
    init(shellController: ShellProvider) {
        self.shellController = shellController
    }
}

extension InstaLoaderViewModel {
    func downloadAll(
        profileId: String,
        skipPictures: Bool,
        skipVideos: Bool,
        destinationPath: String) async -> Bool {
            
            let command = "instaloader"
            let parameters = "--no-caption --no-compress-json --no-profile-pic  --no-video-thumbnails --no-metadata-json"
            let skipVideosParam = skipVideos ? "--no-videos" : ""
            let skipPicturesParam = skipPictures ? "--no-pictures" : ""
            let destinationFolder = "--dirname-pattern \(destinationPath){profile}"
            let finalCommand = [command, parameters, skipVideosParam, skipPicturesParam, destinationFolder, profileId].filter { !$0.isEmpty }.joined(separator: " ")
            let result = await shellController.safeShell(finalCommand, liveOutput: nil)
            return result.status == 0
    }
    
    func downloadWithOutput(profileId: String,
                            skipPictures: Bool,
                            skipVideos: Bool,
                            destinationPath: String,
                            debug: ((String) -> Void)?,
                            compltion: @escaping (Bool)->Void) {
        
        let command = "instaloader"
        let parameters = "--no-caption --no-compress-json --no-profile-pic  --no-video-thumbnails --no-metadata-json"
        let skipVideosParam = skipVideos ? "--no-videos" : ""
        let skipPicturesParam = skipPictures ? "--no-pictures" : ""
        let destinationFolder = "--dirname-pattern \(destinationPath){profile}"
        let finalCommand = [command, parameters, skipVideosParam, skipPicturesParam, destinationFolder, profileId].filter { !$0.isEmpty }.joined(separator: " ")
        
        shellController.executeShell(command: finalCommand, liveOutput: { opt in
            print(opt, Date().description)
            debug?(opt)
        }) { output, result in
            compltion(result == 0)
        }
    }
}
