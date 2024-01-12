//
//  ShellCommandExecutor.swift
//  Tooler
//
//  Created by akash kahalkar on 27/12/23.
//

import Foundation
import Extensions


protocol ShellProvider {
    func safeShell(_ command: String, liveOutput: ((String)->Void)?) async -> (output: String?, status: Int32)
    func executeShell(command: String, liveOutput: ((String)->Void)?, completion: @escaping (String?, Int32)->Void)
    func checkIfPresent(command: String) async -> Bool
}

final class DefaultShellController: ObservableObject, ShellProvider {
    
    enum ShellError: Error {
        case decodingError
    }
    
    func checkIfPresent(command: String) async -> Bool {
        let result = await safeShell("command -v \(command)", liveOutput: nil).status
        return result == 0
    }
    
    func executeShell(command: String, liveOutput: ((String)->Void)?, completion: @escaping (String?, Int32)->Void) {
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
        
        
        let group = DispatchGroup()
        group.enter()
        outputPipe.fileHandleForReading.readabilityHandler = { buffer in
            let data = buffer.availableData
            if data.isEmpty { // EOF
                group.leave()
                return
            }
            if let line = String(data: data, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    print(line, Date().description)
                }
            }
        }
        
        process.terminationHandler = { (task) in
            group.wait()
            let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            let status = task.terminationStatus
            DispatchQueue.main.async {
                completion(output, status)
            }
        }
        
        do {
            try process.run()
        } catch {
            completion(nil, 1)
        }
    }
    
    func safeShell(_ command: String, liveOutput: ((String)->Void)?) async -> (output: String?, status: Int32) {
        
        
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



