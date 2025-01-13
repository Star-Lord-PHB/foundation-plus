#if os(Windows)

import WinSDK
import Foundation


protocol WindowsIntConstant {
    var rawValue: DWORD { get }
    init(_ rawValue: DWORD)
}


extension WindowsIntConstant {
    init(_ rawValue: Int32) {
        self.init(DWORD(rawValue))
    }
}


protocol WindowsMergeableIntConstant: WindowsIntConstant {}


extension WindowsMergeableIntConstant {
    static func | (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.rawValue | rhs.rawValue)
    }
}


extension Collection where Element: WindowsMergeableIntConstant {
    var combinedRawValue: DWORD {
        reduce(0) { $0 | $1.rawValue }
    }
}


struct WindowsFileAccessMode: Sendable, WindowsMergeableIntConstant {

    let rawValue: DWORD

    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    static let genericRead: WindowsFileAccessMode = .init(GENERIC_READ)
    static let genericWrite: WindowsFileAccessMode = .init(GENERIC_WRITE)
    static let genericExecute: WindowsFileAccessMode = .init(GENERIC_EXECUTE)
    static let genericAll: WindowsFileAccessMode = .init(GENERIC_ALL)
    static let delete: WindowsFileAccessMode = .init(DELETE)
    static let synchronize: WindowsFileAccessMode = .init(SYNCHRONIZE)
    static let fileReadAttributes: WindowsFileAccessMode = .init(FILE_READ_ATTRIBUTES)
    static let fileWriteAttributes: WindowsFileAccessMode = .init(FILE_WRITE_ATTRIBUTES)
    static let fileDeleteChild: WindowsFileAccessMode = .init(FILE_DELETE_CHILD)
    static let fileExecute: WindowsFileAccessMode = .init(FILE_EXECUTE)
    static let fileReadEA: WindowsFileAccessMode = .init(FILE_READ_EA)
    static let fileWriteEA: WindowsFileAccessMode = .init(FILE_WRITE_EA)
    static let fileAppendData: WindowsFileAccessMode = .init(FILE_APPEND_DATA)
    static let fileWriteData: WindowsFileAccessMode = .init(FILE_WRITE_DATA)
    static let fileAddSubdirectory: WindowsFileAccessMode = .init(FILE_ADD_SUBDIRECTORY)
    static let fileAddFile: WindowsFileAccessMode = .init(FILE_ADD_FILE)
    static let fileListDirectory: WindowsFileAccessMode = .init(FILE_LIST_DIRECTORY)

}


struct WindowsFileShareMode: Sendable, WindowsMergeableIntConstant {

    let rawValue: DWORD

    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    static let none: WindowsFileShareMode = .init(0)
    static let shareDelete: WindowsFileShareMode = .init(FILE_SHARE_DELETE)
    static let shareRead: WindowsFileShareMode = .init(FILE_SHARE_READ)
    static let shareWrite: WindowsFileShareMode = .init(FILE_SHARE_WRITE)

}


struct WindowsFileCreationMode: Sendable, WindowsIntConstant {
    let rawValue: DWORD

    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    static let createNew: WindowsFileCreationMode = .init(CREATE_NEW)
    static let createAlways: WindowsFileCreationMode = .init(CREATE_ALWAYS)
    static let openExisting: WindowsFileCreationMode = .init(OPEN_EXISTING) 
    static let openAlways: WindowsFileCreationMode = .init(OPEN_ALWAYS)
    static let truncateExisting: WindowsFileCreationMode = .init(TRUNCATE_EXISTING)
}


protocol WindowsFileFlagsAndAttributes: WindowsMergeableIntConstant {}


extension WindowsFileFlagsAndAttributes {
    static func | <Operant: WindowsFileFlagsAndAttributes> (lhs: Self, rhs: Operant) -> AnyWindowsFileFlagsAndAttributes {
        return .init(lhs.rawValue | rhs.rawValue)
    }
}


struct AnyWindowsFileFlagsAndAttributes: WindowsFileFlagsAndAttributes {
    let rawValue: DWORD
    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }
}


struct WindowsFileAttributeOption: Sendable, WindowsFileFlagsAndAttributes {
    let rawValue: DWORD

    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    static let archive: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_ARCHIVE)
    static let encrypted: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_ENCRYPTED)
    static let hidden: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_HIDDEN)
    static let normal: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_NORMAL)
    static let offline: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_OFFLINE)
    static let readonly: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_READONLY)
    static let system: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_SYSTEM)
    static let temporary: WindowsFileAttributeOption = .init(FILE_ATTRIBUTE_TEMPORARY)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileAttributeOption {
    static var fileAttributeOptions: WindowsFileAttributeOption.Type { WindowsFileAttributeOption.self }
}


struct WindowsFileFlag: Sendable, WindowsFileFlagsAndAttributes {
    let rawValue: DWORD

    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }

    static let backupSemantics: WindowsFileFlag = .init(FILE_FLAG_BACKUP_SEMANTICS)
    static let deleteOnClose: WindowsFileFlag = .init(FILE_FLAG_DELETE_ON_CLOSE)
    static let noBuffering: WindowsFileFlag = .init(FILE_FLAG_NO_BUFFERING)
    static let openReparsePoint: WindowsFileFlag = .init(FILE_FLAG_OPEN_REPARSE_POINT)
    static let openNoRecall: WindowsFileFlag = .init(FILE_FLAG_OPEN_NO_RECALL)
    static let overlapped: WindowsFileFlag = .init(FILE_FLAG_OVERLAPPED)
    static let posixSemantics: WindowsFileFlag = .init(FILE_FLAG_POSIX_SEMANTICS)
    static let randomAccess: WindowsFileFlag = .init(FILE_FLAG_RANDOM_ACCESS)
    static let sessionAware: WindowsFileFlag = .init(FILE_FLAG_SESSION_AWARE)
    static let sequentialScan: WindowsFileFlag = .init(FILE_FLAG_SEQUENTIAL_SCAN)
    static let writeThrough: WindowsFileFlag = .init(FILE_FLAG_WRITE_THROUGH)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileFlag {
    static var fileFlags: WindowsFileFlag.Type { WindowsFileFlag.self }
}


struct WindowsFileSecurityQualityOfService: Sendable, WindowsFileFlagsAndAttributes {
    let rawValue: DWORD
    
    init(_ rawValue: DWORD) {
        self.rawValue = rawValue
    }
    
    static let sqosPresent: WindowsFileSecurityQualityOfService = .init(SECURITY_SQOS_PRESENT)
    static let contextTracking: WindowsFileSecurityQualityOfService = .init(SECURITY_CONTEXT_TRACKING)
    static let effectiveOnly: WindowsFileSecurityQualityOfService = .init(SECURITY_EFFECTIVE_ONLY)
}


extension WindowsFileFlagsAndAttributes where Self == WindowsFileSecurityQualityOfService {
    static var fileSecurityQualityOfService: WindowsFileSecurityQualityOfService.Type { WindowsFileSecurityQualityOfService.self }
}

#endif 