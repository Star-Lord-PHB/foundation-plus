import Foundation
import ConcurrencyPlus


#if os(macOS) || os(Linux) || os(Windows)

/// Execute provided shell command
/// - Parameters:
///   - program: The program of the shell command to execute
///   - args: Arguments of the command
/// - Returns: The output of the command
@discardableResult
public func sysCommand(_ program: String, _ args: [String]) throws -> Data? {
    let process = Process()
#if os(Windows)
    process.executableURL = .init(fileURLWithPath: "C:\\Windows\\System32\\cmd.exe")
    process.arguments = ["/c", program] + args
#else
    process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
    process.arguments = [program] + args
#endif

    let pipe = Pipe()
    
    process.standardOutput = pipe
    process.standardError = pipe
    try process.run()
    process.waitUntilExit()

    if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
        return try pipe.fileHandleForReading.readToEnd()
    } else {
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
}


/// Execute provided shell command
/// - Parameters:
///   - program: The program of the shell command to execute
///   - args: Arguments of the command
/// - Returns: The output of the command
@discardableResult
public func sysCommand(_ program: String, _ args: String...) throws -> Data? {
    try sysCommand(program, args)
}


/// Execute provided shell command
/// - Parameters:
///   - program: The program of the shell command to execute
///   - args: Arguments of the command
/// - Returns: The output of the command
///
/// - Note: This operation will automatically be executed on seperate threads
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@discardableResult
public func sysCommand(_ program: String, _ args: [String]) async throws -> Data? {
    
    if #available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *) {
        try await withTaskExecutorPreference(.defaultExecutor.default) {
            try sysCommand(program, args)
        }
    } else {
        try await Task.launch {
            try sysCommand(program, args)
        }
    }
    
}


/// Execute provided shell command
/// - Parameters:
///   - program: The program of the shell command to execute
///   - args: Arguments of the command
/// - Returns: The output of the command
///
/// - Note: This operation will automatically be executed on seperate threads
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@discardableResult
public func sysCommand(_ program: String, _ args: String...) async throws -> Data? {
    try await sysCommand(program, args)
}


#endif
