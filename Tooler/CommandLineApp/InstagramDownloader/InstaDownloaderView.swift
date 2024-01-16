//
//  InstaDownloaderView.swift
//  Tooler
//
//  Created by akash kahalkar on 08/01/24.
//

import SwiftUI

struct InstaDownloaderView: View {
    
    private var viewModel: InstaLoaderViewModel
    @State private var profileId: String = ""
    @State private var skipPictures = false
    @State private var skipVideos = false
    @State private var isDownloading = false
    @State private var destinationPath = ""
    @State private var liveOutput = ""
    private let totalUpdates = 10
    private let updateInterval = 2.0
    
    public init(viewModel: InstaLoaderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Form {
                TextField(
                    "Instagram Id",
                    text: $profileId,
                    prompt: Text("Provide instagram Id here. e.g. \'quicksan.a.i\'")
                ).padding()
                HStack {
                    Toggle(isOn: $skipPictures) {
                        Text("Skip Pictures")
                    }
                    Toggle(isOn: $skipVideos) {
                        Text("Skip Videos")
                    }
                }.padding()
                
                FolderSelectionView(
                    destinationPath: $destinationPath,
                    appId: InstaDownloaderApp.shared.title)
                
                HStack {
                    Button(action: download) {
                        Text("Download").padding()
                    }.disabled(profileId.isEmpty)
                    if isDownloading { ProgressView() }
                }.padding()
            }.padding()
            
            Text("Output: ")
            Text(liveOutput).padding().background(Color.gray.opacity(0.5))
        }
    }
    
    private func download() {
        isDownloading = true
        viewModel.downloadWithOutput(profileId: profileId,
                                     skipPictures: skipPictures,
                                     skipVideos: skipVideos,
                                     destinationPath: destinationPath) { opt in
            withAnimation {
                liveOutput+=opt + "\n"
            }
        } compltion: { status in
            isDownloading = false
        }
        
//        isDownloading = true
//        Task {
//            let _ = await viewModel.downloadAll(
//                profileId: profileId,
//                skipPictures: skipPictures,
//                skipVideos: skipVideos,
//                destinationPath: destinationPath
//            )
//            DispatchQueue.main.async {
//                isDownloading = false
//            }
//        }
    }
}

#Preview {
    InstaDownloaderView(
        viewModel: InstaLoaderViewModel(
            shellController: DefaultShellController()
        )
    )
}
