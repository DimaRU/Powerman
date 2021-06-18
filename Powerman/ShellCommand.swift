//
//  ShellCommand.swift
//  Powerman
//
//  Created by Dmitriy Borovikov on 17.06.2021.
//

import Foundation

func shellCommand(_ command: String) -> (String, Int32) {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return (output, task.terminationStatus)
}
