
#if !os(Windows)

import Foundation


extension stat {

    var fileType: FileAttributeType {
        switch st_mode & S_IFMT {
            case S_IFREG: .typeRegular
            case S_IFDIR: .typeDirectory
            case S_IFLNK: .typeSymbolicLink
            case S_IFCHR: .typeCharacterSpecial
            case S_IFBLK: .typeBlockSpecial
            case S_IFSOCK: .typeSocket
            default: .typeUnknown
        }   
    }

}


extension mode_t {

    var fileType: FileAttributeType {
        switch self & S_IFMT {
            case S_IFREG: .typeRegular
            case S_IFDIR: .typeDirectory
            case S_IFLNK: .typeSymbolicLink
            case S_IFCHR: .typeCharacterSpecial
            case S_IFBLK: .typeBlockSpecial
            case S_IFSOCK: .typeSocket
            default: .typeUnknown
        }   
    }

}


extension FileAttributeType {

    var fileModeBits: mode_t {
        switch self {
            case .typeRegular: S_IFREG
            case .typeDirectory: S_IFDIR
            case .typeSymbolicLink: S_IFLNK
            case .typeCharacterSpecial: S_IFCHR
            case .typeBlockSpecial: S_IFBLK
            case .typeSocket: S_IFSOCK
            default: S_IFREG
        }
    }

}

#endif