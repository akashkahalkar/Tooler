//
//  ShellCommandExecutor.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import Foundation
import Extensions
import NetworkUtilities

protocol ShellProvider {
    func safeShell(_ command: String) async -> (output: String?, status: Int32)
}

final class DefaultShellController: ObservableObject, ShellProvider {
    enum ShellError: Error {
        case decodingError
    }
    
    func checkIfPresent(command: String) async -> Bool {
        let result = await safeShell("command -v \(command)").status
        return result == 0
    }
    
    func safeShell(_ command: String) async -> (output: String?, status: Int32) {
        
        return await withCheckedContinuation { continuation in
            let process = Process()
            let outputPipe = Pipe()
            process.standardOutput = outputPipe
            process.arguments = ["-c", command]
            process.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
            
            // set path
            if let currentPath = ProcessInfo.processInfo.environment["PATH"] {
                let newPath = currentPath + ":/usr/local/bin/"
                process.environment = ["PATH": newPath]
            }
            
            process.terminationHandler = { (task) in
                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)
                let status = task.terminationStatus
                continuation.resume(returning: (output: output, status: status))
            }
                        
            do {
                try process.run()
            } catch {
                continuation.resume(returning: (output: nil, status: 1))
            }
        }
    }
}



