//
//  DownloadView.swift
//  Tooler
//
//  Created by akash kahalkar on 06/01/24.
//

import SwiftUI

struct DownloadView: View {
    
    @State private var url: String = ""
    
    var body: some View {
        Form {
            TextField("", text: $url, prompt: Text("Enter url here"))
                .padding()
            Button(action: download, label: {
                Text("Download").padding()
            })
        }
    }
    
    func download() {
    }
}

#Preview {
    DownloadView()
}
