//
//  BrewPackageList.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import SwiftUI

struct BrewPackageList<T: BrewAppViewModelWrapperProtocol>: View {
    @ObservedObject var viewModel: T
    @State private var uninstalling = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        if viewModel.packages.isEmpty {
            ProgressView().onAppear {
                Task {
                    await viewModel.loadInstalledPackages(forceRefresh: false)
                }
            }
        } else {
            NavigationStack {
                VStack {
                    if uninstalling { ProgressView() } else { listView }
                    Divider()
                    uninstallView
                    Spacer()
                }
            }
        }
    }

    var listView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                ForEach($viewModel.packages) { pkg in
                    Toggle(isOn: pkg.isSelected) {
                        Text(pkg.name.wrappedValue)
                    }
                }
            }
            .padding(.horizontal)
        }.padding()
    }

    var uninstallView: some View {
        HStack {
            if !viewModel.packages.filter({ $0.isSelected }).isEmpty || uninstalling {
                Button {
                    self.uninstalling = true
                    Task {
                        let _ = await viewModel.uninstallSelectedPackages()
                        DispatchQueue.main.async {
                            self.uninstalling = false
                        }
                    }
                } label: {
                    Text("Uninstall Packages").foregroundColor(.pink)
                        .padding()
                }
                .foregroundColor(.white)
                .background(Color.sweetVenom)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    BrewPackageList(
        viewModel: BrewManagerViewModel(shellController: DefaultShellController())
    )
}
