#if os(Linux)

import Foundation
import GlibcInterop


extension FileManager.PlatformFileFlags {

    public static let userVisibleMask: BitValue = .init(FS_FL_USER_VISIBLE)
    public static let userModifiableMask: BitValue = .init(FS_FL_USER_MODIFIABLE)


    public var secureRemove: Bool {
        get { self.bits | .init(FS_SECRM_FL) != 0 }
        set { self.setBits(FS_SECRM_FL, to: newValue) }
    }

    public var unRemove: Bool {
        get { self.bits | .init(FS_UNRM_FL) != 0 }
        set { self.setBits(FS_UNRM_FL, to: newValue) }
    }

    public var isCompressed: Bool {
        get { self.bits | .init(FS_COMPR_FL) != 0 }
        set { self.setBits(FS_COMPR_FL, to: newValue) }
    }

    public var synchronous: Bool {
        get { self.bits | .init(FS_SYNC_FL) != 0 }
        set { self.setBits(FS_SYNC_FL, to: newValue) }
    }

    public var isImmutable: Bool {
        get { self.bits | .init(FS_IMMUTABLE_FL) != 0 }
        set { self.setBits(FS_IMMUTABLE_FL, to: newValue) }
    }

    public var isAppendOnly: Bool {
        get { self.bits | .init(FS_APPEND_FL) != 0 }
        set { self.setBits(FS_APPEND_FL, to: newValue) }
    }

    public var noDump: Bool {
        get { self.bits | .init(FS_NODUMP_FL) != 0 }
        set { self.setBits(FS_NODUMP_FL, to: newValue) }
    }

    public var noAccessTimeUpdate: Bool {
        get { self.bits | .init(FS_NOATIME_FL) != 0 }
        set { self.setBits(FS_NOATIME_FL, to: newValue) }
    }

    public var isDirty: Bool {
        self.bits | .init(FS_DIRTY_FL) != 0
    }

    public var compressedBlocks: Bool {
        self.bits | .init(FS_COMPRBLK_FL) != 0
    }

    public var noCompression: Bool {
        self.bits | .init(FS_NOCOMP_FL) != 0
    }

    public var isEncrypted: Bool {
        self.bits | .init(FS_ENCRYPT_FL) != 0
    }

    public var isBTreeDir: Bool {
        self.bits | .init(FS_BTREE_FL) != 0
    }

    public var isHashIndexedDir: Bool {
        self.bits | .init(FS_INDEX_FL) != 0
    }

    public var isMagicFile: Bool {
        self.bits | .init(FS_IMAGIC_FL) != 0
    }

    public var isJournaledData: Bool {
        get { self.bits | .init(FS_JOURNAL_DATA_FL) != 0 }
        set { self.setBits(FS_JOURNAL_DATA_FL, to: newValue) }
    }

    public var noTailMerging: Bool {
        get { self.bits | .init(FS_NOTAIL_FL) != 0 }
        set { self.setBits(FS_NOTAIL_FL, to: newValue) }
    }

    public var isSynchronousDir: Bool {
        self.bits | .init(FS_DIRSYNC_FL) != 0
    }

    public var isTopDir: Bool {
        self.bits | .init(FS_TOPDIR_FL) != 0
    }

    public var isHugeFile: Bool {
        self.bits | .init(FS_HUGE_FILE_FL) != 0
    }

    public var isExtentFormat: Bool {
        get { self.bits | .init(FS_EXTENT_FL) != 0 }
        set { self.setBits(FS_EXTENT_FL, to: newValue) }
    }

    public var isVerityProtected: Bool {
        self.bits | .init(FS_VERITY_FL) != 0
    }

    public var isEaInode: Bool {
        self.bits | .init(FS_EA_INODE_FL) != 0
    }

    public var isEofBlocks: Bool {
        get { self.bits | .init(FS_EOFBLOCKS_FL) != 0 }
        set { self.setBits(FS_EOFBLOCKS_FL, to: newValue) }
    }

    public var noCopyOnWrite: Bool {
        self.bits | .init(FS_NOCOW_FL) != 0
    }

    public var isDaxInode: Bool {
        get { self.bits | .init(FS_DAX_FL) != 0 }
        set { self.setBits(FS_DAX_FL, to: newValue) }
    }

    public var isInlineData: Bool {
        self.bits | .init(FS_INLINE_DATA_FL) != 0
    }

    public var projinherit: Bool {
        self.bits | .init(FS_PROJINHERIT_FL) != 0
    }

    public var isCaseInsensitiveFolder: Bool {
        self.bits | .init(FS_CASEFOLD_FL) != 0
    }

    public var reserved: Bool {
        self.bits | .init(FS_RESERVED_FL) != 0
    }

}

#endif