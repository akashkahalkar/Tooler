//
//  BrewManagerViewModel.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import Foundation
import SwiftUI

struct Package: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var isSelected: Bool = false

    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: Package, rhs: Package) -> Bool {
        return lhs.name == rhs.name
    }
}

protocol BrewAppViewModellable {
    func loadInstalledPackages(forceRefresh: Bool) async
    func installPackage(_ name: String) async -> (output: String?, success: Bool)
    func uninstallSelectedPackages() async -> Bool
}

protocol BrewAppViewModelWrapperProtocol: ObservableObject, BrewAppViewModellable {
    var packages: [Package] { get set }
}

final class BrewManagerViewModel: ObservableObject, BrewAppViewModelWrapperProtocol {
    private let shellController: ShellProvider
    @Published var packages: [Package] = []

    init(shellController: ShellProvider) {
        self.shellController = shellController
    }

    deinit {
        print(String(describing: self), "deinitialized")
    }

    func loadInstalledPackages(forceRefresh: Bool = false) async {
        if packages.isEmpty || forceRefresh {
            let result = await shellController.safeShell(BrewConstants.Commands.list)
            guard getStatus(result.status),
                  let packagesList = result.output?.components(separatedBy: .newlines)
            else {
                return
            }
            DispatchQueue.main.async {
                self.packages = packagesList.filter { $0 != "" }.map { Package(name: $0) }
            }
        }
    }
}

extension BrewManagerViewModel {
    private func getStatus(_ statusValue: Int32) -> Bool {
        return statusValue == 0 ? true : false
    }

    func installPackage(_ name: String) async -> (output: String?, success: Bool) {
        let result = await shellController.safeShell("brew install \(name)")
        if getStatus(result.status) {
            await loadInstalledPackages(forceRefresh: true)
        }
        return (output: result.output, success: getStatus(result.status))
    }

    private func removeUninstalledPackages(_ packageNames: [String]) {
        DispatchQueue.main.async {
            packageNames.forEach { uninstalledPackage in
                self.packages.removeAll { package in
                    package.name == uninstalledPackage
                }
            }
        }
    }

    func uninstallSelectedPackages() async -> Bool {
        let packagesToUninstall = packages.filter { $0.isSelected }.map { $0.name }
        let spaceSeperatedPackageNames = packagesToUninstall.joined(separator: " ")
        let result = await shellController.safeShell("brew uninstall \(spaceSeperatedPackageNames)")

        if getStatus(result.status) {
            removeUninstalledPackages(packagesToUninstall)
        }

        return getStatus(result.status)
    }
}
