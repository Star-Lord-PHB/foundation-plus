#if os(Windows)

import WinSDK
import Foundation


public protocol WindowsIntConstant {
    var rawValue: DWORD { get }
    init(_ rawValue: DWORD)
}


extension WindowsIntConstant {
    public init(_ rawValue: Int32) {
        self.init(DWORD(rawValue))
    }
}


public protocol WindowsMergeableIntConstant: WindowsIntConstant {}


extension WindowsMergeableIntConstant {
    public static func | (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.rawValue | rhs.rawValue)
    }
}


extension Collection where Element: WindowsMergeableIntConstant {
    public var combinedRawValue: DWORD {
        reduce(0) { $0 | $1.rawValue }
    }
}


public struct WindowsFileAccessMode: Sendable, WindowsMergeableIntConstant {

    public let rawValue: DWORD

    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    public static let genericRead: WindowsFileAccessMode = .init(GENERIC_READ)
    public static let genericWrite: WindowsFileAccessMode = .init(GENERIC_WRITE)
    public static let genericExecute: WindowsFileAccessMode = .init(GENERIC_EXECUTE)
    public static let genericAll: WindowsFileAccessMode = .init(GENERIC_ALL)
    public static let delete: WindowsFileAccessMode = .init(DELETE)
    public static let synchronize: WindowsFileAccessMode = .init(SYNCHRONIZE)
    public static let fileReadAttributes: WindowsFileAccessMode = .init(FILE_READ_ATTRIBUTES)
    public static let fileWriteAttributes: WindowsFileAccessMode = .init(FILE_WRITE_ATTRIBUTES)
    public static let fileDeleteChild: WindowsFileAccessMode = .init(FILE_DELETE_CHILD)
    public static let fileExecute: WindowsFileAccessMode = .init(FILE_EXECUTE)
    public static let fileReadEA: WindowsFileAccessMode = .init(FILE_READ_EA)
    public static let fileWriteEA: WindowsFileAccessMode = .init(FILE_WRITE_EA)
    public static let fileAppendData: WindowsFileAccessMode = .init(FILE_APPEND_DATA)
    public static let fileWriteData: WindowsFileAccessMode = .init(FILE_WRITE_DATA)
    public static let fileAddSubdirectory: WindowsFileAccessMode = .init(FILE_ADD_SUBDIRECTORY)
    public static let fileAddFile: WindowsFileAccessMode = .init(FILE_ADD_FILE)
    public static let fileListDirectory: WindowsFileAccessMode = .init(FILE_LIST_DIRECTORY)

}


public struct WindowsFileShareMode: Sendable, WindowsMergeableIntConstant {

    public let rawValue: DWORD

    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    public static let none: WindowsFileShareMode = .init(0)
    public static let shareDelete: WindowsFileShareMode = .init(FILE_SHARE_DELETE)
    public static let shareRead: WindowsFileShareMode = .init(FILE_SHARE_READ)
    public static let shareWrite: WindowsFileShareMode = .init(FILE_SHARE_WRITE)

}


public struct WindowsFileCreationMode: Sendable, WindowsIntConstant {
    public let rawValue: DWORD

    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    public static let createNew: WindowsFileCreationMode = .init(CREATE_NEW)
    public static let createAlways: WindowsFileCreationMode = .init(CREATE_ALWAYS)
    public static let openExisting: WindowsFileCreationMode = .init(OPEN_EXISTING) 
    public static let openAlways: WindowsFileCreationMode = .init(OPEN_ALWAYS)
    public static let truncateExisting: WindowsFileCreationMode = .init(TRUNCATE_EXISTING)
}


public protocol WindowsFileFlagsAndAttributes: WindowsMergeableIntConstant {}


extension WindowsFileFlagsAndAttributes {
    public static func | <Operant: WindowsFileFlagsAndAttributes> (lhs: Self, rhs: Operant) -> AnyWindowsFileFlagsAndAttributes {
        return .init(lhs.rawValue | rhs.rawValue)
    }
}


public struct AnyWindowsFileFlagsAndAttributes: WindowsFileFlagsAndAttributes {
    public let rawValue: DWORD
    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }
}


public struct WindowsFileAttributeOption: Sendable, WindowsFileFlagsAndAttributes {
    public let rawValue: DWORD

    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    public static let archive: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_ARCHIVE)
    public static let encrypted: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_ENCRYPTED)
    public static let hidden: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_HIDDEN)
    public static let normal: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_NORMAL)
    public static let offline: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_OFFLINE)
    public static let readonly: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_READONLY)
    public static let system: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_SYSTEM)
    public static let temporary: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_TEMPORARY)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileAttributeOption {
    public static var fileAttributeOptions: WindowsFileAttributeOption.Type { WindowsFileAttributeOption.self }
}


public struct WindowsFileFlag: Sendable, WindowsFileFlagsAndAttributes {
    public let rawValue: DWORD

    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    public static let backupSemantics: WindowsFileFlag = .init(FILE_FLAG_BACKUP_SEMANTICS)
    public static let deleteOnClose: WindowsFileFlag = .init(FILE_FLAG_DELETE_ON_CLOSE)
    public static let noBuffering: WindowsFileFlag = .init(FILE_FLAG_NO_BUFFERING)
    public static let openReparsePoint: WindowsFileFlag = .init(FILE_FLAG_OPEN_REPARSE_POINT)
    public static let openNoRecall: WindowsFileFlag = .init(FILE_FLAG_OPEN_NO_RECALL)
    public static let overlapped: WindowsFileFlag = .init(FILE_FLAG_OVERLAPPED)
    public static let posixSemantics: WindowsFileFlag = .init(FILE_FLAG_POSIX_SEMANTICS)
    public static let randomAccess: WindowsFileFlag = .init(FILE_FLAG_RANDOM_ACCESS)
    public static let sessionAware: WindowsFileFlag = .init(FILE_FLAG_SESSION_AWARE)
    public static let sequentialScan: WindowsFileFlag = .init(FILE_FLAG_SEQUENTIAL_SCAN)
    public static let writeThrough: WindowsFileFlag = .init(FILE_FLAG_WRITE_THROUGH)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileFlag {
    public static var fileFlags: WindowsFileFlag.Type { WindowsFileFlag.self }
}


public struct WindowsFileSecurityQualityOfService: Sendable, WindowsFileFlagsAndAttributes {
    public let rawValue: DWORD
    
    public init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }
    
    public static let sqosPresent: WindowsFileSecurityQualityOfService = .init(SECURITY_SQOS_PRESENT)
    public static let contextTracking: WindowsFileSecurityQualityOfService = .init(SECURITY_CONTEXT_TRACKING)
    public static let effectiveOnly: WindowsFileSecurityQualityOfService = .init(SECURITY_EFFECTIVE_ONLY)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileSecurityQualityOfService {
    public static var fileSecurityQualityOfService: WindowsFileSecurityQualityOfService.Type { WindowsFileSecurityQualityOfService.self }
}

#endif 