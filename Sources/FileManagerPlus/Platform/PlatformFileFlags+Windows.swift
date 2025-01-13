
#if os(Windows)

import Foundation
import WinSDK


extension FileManager.PlatformFileFlags {

    /// FILE_ATTRIBUTE_READONLY
    public var isReadOnly: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_READONLY != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_READONLY), to: newValue) }
    }

    /// FILE_ATTRIBUTE_HIDDEN
    public var isHidden: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_HIDDEN != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_HIDDEN), to: newValue) }
    }

    /// FILE_ATTRIBUTE_SYSTEM
    public var isSystem: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_SYSTEM != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_SYSTEM), to: newValue) }
    }

    /// FILE_ATTRIBUTE_ARCHIVE
    public var isArchive: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_ARCHIVE != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_ARCHIVE), to: newValue) }
    }

    /// FILE_ATTRIBUTE_DEVICE
    public var isDevice: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_DEVICE != 0
    }

    /// FILE_ATTRIBUTE_NORMAL
    public var isNormal: Bool { 
        get { Int32(bits) == FILE_ATTRIBUTE_NORMAL }
        set { if newValue { bits = DWORD(FILE_ATTRIBUTE_NORMAL) } else { bits &= DWORD(~FILE_ATTRIBUTE_NORMAL) } }
    }

    /// FILE_ATTRIBUTE_TEMPORARY
    public var isTemporary: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_TEMPORARY != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_TEMPORARY), to: newValue) }
    }

    /// FILE_ATTRIBUTE_SPARSE_FILE
    public var isSparseFile: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_SPARSE_FILE != 0
    }

    /// FILE_ATTRIBUTE_REPARSE_POINT
    public var isReparsePoint: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_REPARSE_POINT != 0
    }

    /// FILE_ATTRIBUTE_COMPRESSED
    public var isCompressed: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_COMPRESSED != 0
    }

    /// FILE_ATTRIBUTE_OFFLINE
    public var isOffline: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_OFFLINE != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_OFFLINE), to: newValue) }
    }

    /// FILE_ATTRIBUTE_NOT_CONTENT_INDEXED
    public var notContentIndexed: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_NOT_CONTENT_INDEXED != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_NOT_CONTENT_INDEXED), to: newValue) }
    }

    /// FILE_ATTRIBUTE_ENCRYPTED
    public var isEncrypted: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_ENCRYPTED != 0
    }

    /// FILE_ATTRIBUTE_INTEGRITY_STREAM
    public var isIntegrityStream: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_INTEGRITY_STREAM != 0
    }

    /// FILE_ATTRIBUTE_VIRTUAL
    public var isVirtual: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_VIRTUAL != 0
    }

    /// FILE_ATTRIBUTE_NO_SCRUB_DATA
    public var noScrubData: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_NO_SCRUB_DATA != 0
    }

    /// FILE_ATTRIBUTE_EA
    public var isEA: Bool { 
        get { Int32(bits) & FILE_ATTRIBUTE_EA != 0 }
        set { setBits(DWORD(FILE_ATTRIBUTE_EA), to: newValue) }
    }

    /// FILE_ATTRIBUTE_PINNED
    public var pinned: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_PINNED != 0
    }

    /// FILE_ATTRIBUTE_UNPINNED
    public var unpinned: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_UNPINNED != 0
    }

    /// FILE_ATTRIBUTE_RECALL_ON_OPEN
    public var recallOnOpen: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_RECALL_ON_OPEN != 0
    }
    
    /// FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS
    public var recallOnDataAccess: Bool { 
        Int32(bits) & FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS != 0
    }

}

#endif