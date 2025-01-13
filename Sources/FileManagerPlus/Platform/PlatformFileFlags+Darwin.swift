#if canImport(Darwin)

import Foundation


extension FileManager.PlatformFileFlags {

    /// SF_ARCHIVED
    public var isArchived: Bool {
        get { self.bits & .init(SF_ARCHIVED) != 0 }
        set { setBits(SF_ARCHIVED, to: newValue) }
    }

    /// UF_NODUMP
    public var noDump: Bool {
        get { self.bits & .init(UF_NODUMP) != 0 }
        set { setBits(UF_NODUMP, to: newValue) }
    }

    /// UF_OPAQUE
    public var isOpaque: Bool {
        get { self.bits & .init(UF_OPAQUE) != 0 }
        set { setBits(UF_OPAQUE, to: newValue) }
    }

    /// SF_APPEND
    public var isSystemAppendOnly: Bool {
        get { self.bits & .init(SF_APPEND) != 0 }
        set { setBits(SF_APPEND, to: newValue) }
    }

    /// UF_APPEND
    public var isUserAppendOnly: Bool {
        get { self.bits & .init(UF_APPEND) != 0 }
        set { setBits(UF_APPEND, to: newValue) }
    }

    /// SF_IMMUTABLE
    public var isSystemImmutable: Bool {
        get { self.bits & .init(SF_IMMUTABLE) != 0 }
        set { setBits(SF_IMMUTABLE, to: newValue) }
    }

    /// UF_IMMUTABLE
    public var isUserImmutable: Bool {
        get { self.bits & .init(UF_IMMUTABLE) != 0 }
        set { setBits(UF_IMMUTABLE, to: newValue) }
    }

    /// UF_HIDDEN
    public var isHidden: Bool {
        get { self.bits & .init(UF_HIDDEN) != 0 }
        set { setBits(UF_HIDDEN, to: newValue) }
    }

    /// SF_NOUNLINK
    public var noUnlink: Bool {
        self.bits & .init(SF_NOUNLINK) != 0
    }

    /// UF_COMPRESSED
    public var isCompressed: Bool {
        self.bits & .init(UF_COMPRESSED) != 0
    }

    /// UF_DATAVAULT
    public var isDataVault: Bool {
        self.bits & .init(UF_DATAVAULT) != 0
    }

    /// UF_TRACKED
    public var isTracked: Bool {
        get { self.bits & .init(UF_TRACKED) != 0 }
        set { setBits(UF_TRACKED, to: newValue) }
    }

    /// SF_DATALESS
    public var isDataless: Bool {
        self.bits & .init(SF_DATALESS) != 0
    }

    /// SF_FIRMLINK
    public var isFirmLink: Bool {
        self.bits & .init(SF_FIRMLINK) != 0
    }

    /// SF_RESTRICTED
    public var isRestricted: Bool {
        self.bits & .init(SF_RESTRICTED) != 0
    }

    /// SF_SUPPORTED
    public var isSupported: Bool {
        self.bits & .init(SF_SUPPORTED) != 0
    }

    /// SF_SYNTHETIC
    public var isSynthetic: Bool {
        self.bits & .init(SF_SYNTHETIC) != 0
    }


    /// SF_SETTABLE
    public static let systemSettableBits: BitValue = .init(SF_SETTABLE)

    /// SF_SUPPORTED
    public static let systemSupportedBits: BitValue = .init(SF_SUPPORTED)

    /// UF_SETTABLE
    public static let userSettableBits: BitValue = .init(UF_SETTABLE)

}

#endif