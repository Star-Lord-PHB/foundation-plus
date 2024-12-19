
#if os(Windows)
import Foundation
import WinSDK


extension FileManager.FileInfo {

    public var isReadOnly: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_READONLY != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_READONLY), to: newValue) }
    }

    public var isHidden: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_HIDDEN != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_HIDDEN), to: newValue) }
    }

    public var isSystem: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_SYSTEM != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_SYSTEM), to: newValue) }
    }

    public var isArchive: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_ARCHIVE != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_ARCHIVE), to: newValue) }
    }

    public var isDevice: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_DEVICE != 0
    }

    public var isNormal: Bool { 
        get { Int32(fileAttributes) == FILE_ATTRIBUTE_NORMAL }
        set { if newValue { fileAttributes = DWORD(FILE_ATTRIBUTE_NORMAL) } else { fileAttributes &= DWORD(~FILE_ATTRIBUTE_NORMAL) } }
    }

    public var isTemporary: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_TEMPORARY != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_TEMPORARY), to: newValue) }
    }

    public var isSparseFile: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_SPARSE_FILE != 0
    }

    public var isReparsePoint: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_REPARSE_POINT != 0
    }

    public var isCompressed: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_COMPRESSED != 0
    }
    public var isOffline: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_OFFLINE != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_OFFLINE), to: newValue) }
    }

    public var notContentIndexed: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_NOT_CONTENT_INDEXED != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_NOT_CONTENT_INDEXED), to: newValue) }
    }

    public var isEncrypted: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_ENCRYPTED != 0
    }

    public var isIntegrityStream: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_INTEGRITY_STREAM != 0
    }

    public var isVirtual: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_VIRTUAL != 0
    }
    public var noScrubData: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_NO_SCRUB_DATA != 0
    }

    public var isEA: Bool { 
        get { Int32(fileAttributes) & FILE_ATTRIBUTE_EA != 0 }
        set { setBits(for: &fileAttributes, at: DWORD(FILE_ATTRIBUTE_EA), to: newValue) }
    }

    public var pinned: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_PINNED != 0
    }

    public var unpinned: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_UNPINNED != 0
    }

    public var recallOnOpen: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_RECALL_ON_OPEN != 0
    }
    
    public var recallOnDataAccess: Bool { 
        Int32(fileAttributes) & FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS != 0
    }

}


extension FileManager.FileInfo {

    fileprivate func setBits<T: BinaryInteger>(for value: inout T, at mask: T, to active: Bool) {
        if active {
            value |= mask
        } else {
            value &= ~mask
        }
    }

}

#endif 