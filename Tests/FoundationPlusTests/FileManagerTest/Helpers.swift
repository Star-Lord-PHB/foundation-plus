import Foundation
import SystemPackage
import Testing
import FileManagerPlus
#if os(Windows)
import WinSDK
#endif


#if os(Windows)

func getCurrentUserSID() throws -> String {

    var tokenHandle: HANDLE?
    var tokenInformation: UnsafeMutableRawPointer?
    var tokenInformationLength: DWORD = 0

    // Open the access token associated with the current process
    try #require(OpenProcessToken(GetCurrentProcess(), DWORD(TOKEN_QUERY), &tokenHandle), "Failed to open process token")

    // Get the size of the token information
    GetTokenInformation(tokenHandle, TokenUser, nil, 0, &tokenInformationLength)
    tokenInformation = UnsafeMutableRawPointer.allocate(byteCount: Int(tokenInformationLength), alignment: 1)

    defer { 
        CloseHandle(tokenHandle)
        tokenInformation?.deallocate() 
    }

    try #require(
        GetTokenInformation(tokenHandle, TokenUser, tokenInformation, tokenInformationLength, &tokenInformationLength), 
        "Failed to get token information"
    )

    let tokenUser = tokenInformation?.assumingMemoryBound(to: TOKEN_USER.self)
    let sid = tokenUser?.pointee.User.Sid

    var sidString: LPWSTR?
    try #require(ConvertSidToStringSidW(sid, &sidString), "Failed to convert SID to string")

    let sidStringSwift = String(decodingCString: sidString!, as: UTF16.self)
    LocalFree(sidString)

    return sidStringSwift

}


func getFileOwnerSidWithCmd(at path: FilePath) async throws -> String {

    let process = Process()
    process.executableURL = .init(filePath: "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe")
    process.arguments = [
        "-Command", 
        "(Get-Acl '\(path.string)').Owner | ForEach-Object { (New-Object System.Security.Principal.NTAccount($_)).Translate([System.Security.Principal.SecurityIdentifier]).Value }"
    ]
    
    let pipe = Pipe()
    process.standardOutput = pipe

    try await withTaskCancellationHandler { 
        try await withCheckedThrowingContinuation { continuation in
            process.terminationHandler = { _ in
                continuation.resume()
            }
            do {
                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    } onCancel: {
        process.terminate()
    }

    let data = try {
        try pipe.fileHandleForReading.readToEnd() ?? .init()
    }()

    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

}

#endif



extension FileManager.FileTimeStamp {

    func adding(seconds: Int64, nanoseconds: UInt64) -> FileManager.FileTimeStamp {
        return .init(seconds: self.seconds + seconds, nanoseconds: self.nanoseconds + nanoseconds)
    }

}


extension Date? {

    func approximateEqual(to other: Date?, within timeInterval: TimeInterval = 10e-6) -> Bool {
        if self == nil && other == nil { return true }
        guard let self, let other else { return false }
        return abs(self.timeIntervalSince(other)) <= timeInterval
    }

}


extension Date {

    func approximateEqual(to other: Date?, within timeInterval: TimeInterval = 10e-6) -> Bool {
        guard let other else { return false }
        return abs(self.timeIntervalSince(other)) <= timeInterval
    }

}