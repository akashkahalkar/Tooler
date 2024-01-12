//
//  DownloadView.swift
//  Tooler
//
//  Created by akash kahalkar on 06/01/24.
//

import SwiftUI
import AppKit

struct DownloadView: View {
    
    private var vm = YtDownloaderViewModel()
    
    @State private var url: String = ""
    @State private var isDownloading = false
    @State private var downloadStatus: String = ""
    @State private var destinationPath: String = ""
    
    
    var body: some View {
        VStack {
            Form {
                // enter download url
                HStack {
                    TextField("URL",
                              text: $url,
                              prompt: Text("Enter url here")
                    ).padding()
                        .foregroundColor(.black.opacity(0.7))
                        .tint(.black)
                        .textFieldStyle(.plain)
                    
                    if isDownloading { ProgressView().tint(.red).controlSize(.small).padding(.horizontal) }
                }.background(Color.red.opacity(0))
                    .background(
                        Rectangle().fill(
                            LinearGradient(
                                colors: [.teal.opacity(0.8),
                                         .teal,
                                         .teal.opacity(0.8),
                                         .teal],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ))
                    )
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .padding(.horizontal)
                
                // choose destination folder
                FolderSelectionView(destinationPath: $destinationPath,
                                    appId: YTDLApp.shared.title)
            }.padding(.vertical)
            
            Button(action: download, label: {
                Text("Download")
                    .padding()
                    .background(Rectangle().fill(Color.red))
                    .cornerRadius(8)
                    .shadow(
                        color: .white,
                        radius: url.isEmpty ? 0 : 8,
                        x: 0, y: 0)
            })
            .disabled(url.isEmpty || isDownloading || destinationPath.isEmpty)
            .buttonStyle(.borderless)
            
            // progressView
            if isDownloading { ProgressView() }
            
            //download status
            Text(downloadStatus).font(.system(size: 12, weight: .bold))
            Spacer()
        }.padding(24)
            .background(Rectangle().fill(
                LinearGradient(
                    colors: [.red, .red.opacity(0.8), .orange, .red.opacity(0.8), .red],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing)
            ))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 0)
            .padding()
            .onAppear() {
                if let pastboardString = NSPasteboard.general.string(forType: .string),
                   pastboardString.contains("http") {
                    self.url = pastboardString
                }
            }
    }
    
    func download() {
        isDownloading = true
        Task {
            let result = await vm.download(url: self.url, destinationPath: self.destinationPath)
            DispatchQueue.main.async {
                isDownloading = false
                downloadStatus = "Download complete status \(result ? "Success" : "Failed")"
                
            }
        }
    }
}

#Preview {
    DownloadView()
}
