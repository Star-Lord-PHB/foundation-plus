#if canImport(Darwin)

import Foundation


extension FileManager.PlatformFileFlags {

    public var isArchived: Bool {
        get { self.bits & .init(SF_ARCHIVED) != 0 }
        set { setBits(SF_ARCHIVED, to: newValue) }
    }

    public var noDump: Bool {
        get { self.bits & .init(UF_NODUMP) != 0 }
        set { setBits(UF_NODUMP, to: newValue) }
    }

    public var isOpaque: Bool {
        get { self.bits & .init(UF_OPAQUE) != 0 }
        set { setBits(UF_OPAQUE, to: newValue) }
    }

    public var isSystemAppendOnly: Bool {
        get { self.bits & .init(SF_APPEND) != 0 }
        set { setBits(SF_APPEND, to: newValue) }
    }

    public var isUserAppendOnly: Bool {
        get { self.bits & .init(UF_APPEND) != 0 }
        set { setBits(UF_APPEND, to: newValue) }
    }

    public var isSystemImmutable: Bool {
        get { self.bits & .init(SF_IMMUTABLE) != 0 }
        set { setBits(SF_IMMUTABLE, to: newValue) }
    }

    public var isUserImmutable: Bool {
        get { self.bits & .init(UF_IMMUTABLE) != 0 }
        set { setBits(UF_IMMUTABLE, to: newValue) }
    }

    public var isHidden: Bool {
        get { self.bits & .init(UF_HIDDEN) != 0 }
        set { setBits(UF_HIDDEN, to: newValue) }
    }

    public var noUnlink: Bool {
        self.bits & .init(SF_NOUNLINK) != 0
    }

    public var isCompressed: Bool {
        self.bits & .init(UF_COMPRESSED) != 0
    }

    public var isDataVault: Bool {
        self.bits & .init(UF_DATAVAULT) != 0
    }

    public var isTracked: Bool {
        get { self.bits & .init(UF_TRACKED) != 0 }
        set { setBits(UF_TRACKED, to: newValue) }
    }

    public var isDataless: Bool {
        self.bits & .init(SF_DATALESS) != 0
    }

    public var isFirmLink: Bool {
        self.bits & .init(SF_FIRMLINK) != 0
    }

    public var isRestricted: Bool {
        self.bits & .init(SF_RESTRICTED) != 0
    }

    public var isSupported: Bool {
        self.bits & .init(SF_SUPPORTED) != 0
    }

    public var isSynthetic: Bool {
        self.bits & .init(SF_SYNTHETIC) != 0
    }


    public static let systemSettableBits: BitValue = .init(SF_SETTABLE)

    public static let systemSupportedBits: BitValue = .init(SF_SUPPORTED)

    public static let userSettableBits: BitValue = .init(UF_SETTABLE)

}

#endif