//
//  FolderSelectionView.swift
//  Tooler
//
//  Created by akash kahalkar on 09/01/24.
//

import SwiftUI

struct FolderSelectionView: View {
    
    @Binding var destinationPath: String
    var appId: String
    
    init(destinationPath: Binding<String>,
         appId: String) {
        
        self._destinationPath = destinationPath
        self.appId = appId
    }
    
    private var lastUsedPathKey: String {
        return "\(appId)_lastUsedPath"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Destionation Path")
            TextField("", text: $destinationPath)
            Button("choose destination Folder", systemImage: "folder.fill") {
                chooseDestinationPath()
            }
        }.padding(.vertical).onAppear(perform: {
            if let lastUsedPath = UserDefaults.standard.string(forKey: lastUsedPathKey),
               !lastUsedPath.isEmpty {
                self.destinationPath = lastUsedPath
            }
        })
    }
    
    func chooseDestinationPath() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.isAccessoryViewDisclosed = false
        
        if panel.runModal() == .OK, let path = panel.url?.path() {
            self.destinationPath = path
            UserDefaults.standard.setValue(path, forKey: lastUsedPathKey)
        }
    }
}

//#Preview {
//    FolderSelectionView(destinationPath: .constant(""))
//}
