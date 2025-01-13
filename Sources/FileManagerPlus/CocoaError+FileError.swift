//
//  CocoaError.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/13.
//

import Foundation
import FoundationPlusEssential
import SystemPackage
#if os(Windows)
import CRT
import WinSDK
#endif


extension CocoaError {
    
    /// Create a CocoaError specific for errors related to files
    /// - Parameters:
    ///   - code: The error code
    ///   - url: The url that cause the error
    ///   - underlyingError: The underlying error causing this error (e.g.: POSIXError or WindowsError)
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    /// 
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func fileError(
        _ code: Code,
        url: URL,
        underlyingError: (any Error)? = nil,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        var userInfo = [String: Any]()
        userInfo[NSURLErrorKey] = url
        userInfo[NSUnderlyingErrorKey] = underlyingError as Any
        userInfo["NSUserStringVariant"] = variant
        userInfo["NSSourceFilePathErrorKey"] = source
        userInfo["NSDestinationFilePath"] = destination
        return .init(code, userInfo: userInfo)
    }


    /// Create a CocoaError specific for errors related to files
    /// - Parameters:
    ///   - code: The error code
    ///   - path: The file path that cause the error
    ///   - underlyingError: The underlying error causing this error (e.g.: POSIXError or WindowsError)
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    /// 
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func fileError(
        _ code: Code,
        path: FilePath,
        underlyingError: (any Error)? = nil,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        var userInfo = [String: Any]()
        userInfo[NSFilePathErrorKey] = path.string
        userInfo[NSUnderlyingErrorKey] = underlyingError as Any
        userInfo["NSUserStringVariant"] = variant
        userInfo["NSSourceFilePathErrorKey"] = source
        userInfo["NSDestinationFilePath"] = destination
        return .init(code, userInfo: userInfo)
    }


    /// Create a CocoaError with an POSIX error as the underlying error
    /// - Parameters:
    ///   - path: The file path that cause the error
    ///   - posixError: The causing POSIX error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    /// 
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func posixError(
        path: FilePath,
        posixError: POSIXError,
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let code = CocoaError.Code(fileErrno: posixError.code.rawValue, reading: reading)
        return .fileError(code, path: path, underlyingError: posixError, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with an POSIX error as the underlying error
    /// - Parameters:
    ///   - url: The url that cause the error
    ///   - posixError: The causing POSIX error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    /// 
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func posixError(
        url: URL,
        posixError: POSIXError,
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let code = CocoaError.Code(fileErrno: posixError.code.rawValue, reading: reading)
        return .fileError(code, url: url, underlyingError: posixError, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with the last POSIX error as the underlying error
    /// - Parameters:
    ///   - path: The file path that cause the error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    ///
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func lastPosixError(
        path: FilePath, 
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let posixError = POSIXError(errno: errno)
        let code = CocoaError.Code(fileErrno: errno, reading: reading)
        return .fileError(code, path: path, underlyingError: posixError, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with the last POSIX error as the underlying error
    /// - Parameters:
    ///   - url: The url that cause the error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    /// 
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func lastPosixError(
        url: URL, 
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let posixError = POSIXError(errno: errno)
        let code = CocoaError.Code(fileErrno: errno, reading: reading)
        return .fileError(code, url: url, underlyingError: posixError, variant: variant, source: source, destination: destination)
    }


#if os(Windows)

    /// Create a CocoaError with a WindowsError as the underlying error
    /// - Parameters:
    ///   - path: The file path that cause the error
    ///   - win32Error: The causing WindowsError
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    ///
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func win32Error(
        path: FilePath,
        win32Error: WindowsError,
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let code = CocoaError.Code(win32: win32Error.code, reading: reading)
        return .fileError(code, path: path, underlyingError: win32Error, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with a WindowsError as the underlying error
    /// - Parameters:
    ///   - url: The url that cause the error
    ///   - win32Error: The causing WindowsError
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    ///
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func win32Error(
        url: URL,
        win32Error: WindowsError,
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let code = CocoaError.Code(win32: win32Error.code, reading: reading)
        return .fileError(code, url: url, underlyingError: win32Error, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with the last WindowsError as the underlying error
    /// - Parameters:
    ///   - path: The file path that cause the error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    ///
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func lastWin32Error(
        path: FilePath, 
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let lastErrorCode = GetLastError()
        let win32Error = WindowsError(code: lastErrorCode)
        let code = CocoaError.Code(win32: lastErrorCode, reading: reading)
        return .fileError(code, path: path, underlyingError: win32Error, variant: variant, source: source, destination: destination)
    }


    /// Create a CocoaError with the last WindowsError as the underlying error
    /// - Parameters:
    ///   - url: The url that cause the error
    ///   - reading: Whether the error is caused by actions related to reading files
    ///   - variant: A variant of the error message
    ///   - source: The source file path (if any)
    ///   - destination: The destination file path (if any)
    ///
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public static func lastWin32Error(
        url: URL, 
        reading: Bool,
        variant: String? = nil,
        source: String? = nil,
        destination: String? = nil
    ) -> Self {
        let lastErrorCode = GetLastError()
        let win32Error = WindowsError(code: lastErrorCode)
        let code = CocoaError.Code(win32: lastErrorCode, reading: reading)
        return .fileError(code, url: url, underlyingError: win32Error, variant: variant, source: source, destination: destination)
    }
    
#endif
    
}



extension CocoaError.Code {

    /// Create a CocoaError.Code from a POSIX error code
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    public init(fileErrno: Int32, reading: Bool) {
        self = if reading {
                switch fileErrno {
                case EFBIG: .fileReadTooLarge
                case ENOENT: .fileReadNoSuchFile
                case EPERM, EACCES: .fileReadNoPermission
                case ENAMETOOLONG: .fileReadInvalidFileName
                default: .fileReadUnknown
            }
        } else {
            switch fileErrno {
                case ENOENT: .fileNoSuchFile
                case EPERM, EACCES: .fileWriteNoPermission
                case ENAMETOOLONG: .fileWriteInvalidFileName
#if !os(Windows)
                case EDQUOT: .fileWriteOutOfSpace
#endif
                case ENOSPC: .fileWriteOutOfSpace
                case EROFS: .fileWriteVolumeReadOnly
                case EEXIST: .fileWriteFileExists
                default: .fileWriteUnknown
            }
        }
    }


#if os(Windows)

    /// Create a CocoaError.Code from a Windows error code
    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    init(win32: DWORD, reading: Bool, emptyPath: Bool? = nil) {

        self = switch (reading, Int32(win32)) {

            case (true, ERROR_FILE_NOT_FOUND), (true, ERROR_PATH_NOT_FOUND):
                (emptyPath ?? false) ? .fileReadInvalidFileName : .fileReadNoSuchFile
            case (true, ERROR_ACCESS_DENIED): .fileReadNoPermission
            case (true, ERROR_INVALID_ACCESS): .fileReadNoPermission
            case (true, ERROR_INVALID_DRIVE): .fileReadNoSuchFile
            case (true, ERROR_SHARING_VIOLATION): .fileReadNoPermission
            case (true, ERROR_INVALID_NAME): .fileReadInvalidFileName
            case (true, ERROR_LABEL_TOO_LONG): .fileReadInvalidFileName
            case (true, ERROR_BAD_PATHNAME): .fileReadInvalidFileName
            case (true, ERROR_FILENAME_EXCED_RANGE): .fileReadInvalidFileName
            case (true, ERROR_DIRECTORY): .fileReadInvalidFileName
            case (true, _): .fileReadUnknown
                
            case (false, ERROR_FILE_NOT_FOUND), (false, ERROR_PATH_NOT_FOUND):
                (emptyPath ?? false) ? .fileWriteInvalidFileName : .fileNoSuchFile
            case (false, ERROR_ACCESS_DENIED): .fileWriteNoPermission
            case (false, ERROR_INVALID_ACCESS): .fileWriteNoPermission
            case (false, ERROR_INVALID_DRIVE): .fileNoSuchFile
            case (false, ERROR_WRITE_FAULT): .fileWriteVolumeReadOnly
            case (false, ERROR_SHARING_VIOLATION): .fileWriteNoPermission
            case (false, ERROR_FILE_EXISTS): .fileWriteFileExists
            case (false, ERROR_DISK_FULL): .fileWriteOutOfSpace
            case (false, ERROR_INVALID_NAME): .fileWriteInvalidFileName
            case (false, ERROR_LABEL_TOO_LONG): .fileWriteInvalidFileName
            case (false, ERROR_BAD_PATHNAME): .fileWriteInvalidFileName
            case (false, ERROR_ALREADY_EXISTS): .fileWriteFileExists
            case (false, ERROR_FILENAME_EXCED_RANGE): .fileWriteInvalidFileName
            case (false, ERROR_DIRECTORY): .fileWriteInvalidFileName
            case (false, ERROR_DISK_RESOURCES_EXHAUSTED): .fileWriteOutOfSpace
            case (false, _): .fileWriteUnknown

        }

    }

#endif

}