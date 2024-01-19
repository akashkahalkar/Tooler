//
//  BrewManagerView.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import SwiftUI

struct BrewManagerView<T: BrewAppViewModelWrapperProtocol>: View {
    private var viewModel: T
    @State private var packageName = ""
    @State private var isInstalling = false
    @State private var error: String = ""

    public init(viewModel: T) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Section("Install Package") {
                Form {
                    HStack {
                        TextField("Enter package name",
                                  text: $packageName,
                                  prompt: Text("Package Name here. e.g. wwdc")).padding()
                            .textFieldStyle(.plain)
                            .frame(maxWidth: 500)

                        Button(action: installPackage) {
                            Text("Install")
                                .foregroundColor(Color.pink).padding()
                        }
                        .background(Color.sweetVenom)
                        .disabled(packageName.isEmpty)
                        .clipped().cornerRadius(8).padding(.horizontal)
                        // show progress view while installing
                        if isInstalling { ProgressView() }
                    }
                    Text(error)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Package Manager")
        }
    }

    func installPackage() {
        isInstalling = true
        Task {
            let result = await viewModel.installPackage(packageName)
            if result.success {
                await viewModel.loadInstalledPackages(forceRefresh: false)
            }
            DispatchQueue.main.async {
                isInstalling = false
                if result.success {
                    error = "Success \n \(result.output ?? "")"
                } else {
                    error = "Failed to install package"
                }
            }
        }
    }
}

#Preview {
    BrewManagerView(
        viewModel: BrewManagerViewModel(shellController: DefaultShellController())
    )
}
