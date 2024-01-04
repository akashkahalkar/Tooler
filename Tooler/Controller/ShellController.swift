//
//  ShellCommandExecutor.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import Foundation

protocol ShellProvider {
    func safeShell(_ command: String, outputHandle: FileHandle?) async -> (output: String?, status: Int32)
}

final class DefaultShellController: ObservableObject, ShellProvider {
    enum ShellError: Error {
        case decodingError
    }
    
    func safeShell(_ command: String, outputHandle: FileHandle? = nil) async -> (output: String?, status: Int32) {
        
        await withCheckedContinuation { continuation in
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



