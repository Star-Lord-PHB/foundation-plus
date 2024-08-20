//
//  URLResourceValues+FileSecurity.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/10.
//

import Foundation


extension URLResourceValues {
    
    /// The file mode information of the file
    public var fileMode: UInt16? {
        get {
            guard let fileSecurity else { return nil }
            var mode = 0 as mode_t
            return CFFileSecurityGetMode(fileSecurity, &mode) ? mode : nil
        }
        set {
            guard let newValue else {
                guard let fileSecurity else { return }
                CFFileSecurityClearProperties(fileSecurity, .mode)
                return
            }
            let fileSecurity = fileSecurity ?? .init()
            CFFileSecuritySetMode(fileSecurity, newValue)
            self.fileSecurity = fileSecurity
        }
    }
    
    
    /// The posix permission information of the file
    public var posixPermission: UInt16? {
        get {
            guard let fileMode else { return nil }
            return fileMode & ((1 << 9) - 1)
        }
        set {
            if newValue == nil && fileSecurity == nil {
                return
            }
            let newValue = (newValue ?? 0) & ((1 << 9) - 1)
            let fileMode = ((fileMode ?? 0) & (((1 << 7) - 1) << 9)) | newValue
            self.fileMode = fileMode
        }
    }
    
    
    /// The UID of the owner of the file
    public var ownerUID: UInt32? {
        get {
            guard let fileSecurity else { return nil }
            var uid = 0 as uid_t
            return CFFileSecurityGetOwner(fileSecurity, &uid) ? uid : nil
        }
        set {
            guard let newValue else {
                guard let fileSecurity else { return }
                CFFileSecurityClearProperties(fileSecurity, .owner)
                return
            }
            let fileSecurity = fileSecurity ?? .init()
            CFFileSecuritySetOwner(fileSecurity, newValue)
            self.fileSecurity = fileSecurity
        }
    }
    
    
    /// The GID of the owner of the file
    public var ownerGID: UInt32? {
        get {
            guard let fileSecurity else { return nil }
            var gid = 0 as gid_t
            return CFFileSecurityGetGroup(fileSecurity, &gid) ? gid : nil
        }
        set {
            guard let newValue else {
                guard let fileSecurity else { return }
                CFFileSecurityClearProperties(fileSecurity, .group)
                return
            }
            let fileSecurity = fileSecurity ?? .init()
            CFFileSecuritySetGroup(fileSecurity, newValue)
            self.fileSecurity = fileSecurity
        }
    }
    
    
    /// The access control list of the file
    public var accessControlList: acl_t? {
        get {
            guard let fileSecurity else { return nil }
            var acl: acl_t? = nil
            return CFFileSecurityCopyAccessControlList(fileSecurity, &acl) ? acl : nil
        }
        set {
            guard let newValue else {
                guard let fileSecurity else { return }
                CFFileSecurityClearProperties(fileSecurity, .accessControlList)
                return
            }
            let fileSecurity = fileSecurity ?? .init()
            CFFileSecuritySetAccessControlList(fileSecurity, newValue)
            self.fileSecurity = fileSecurity
        }
    }
    
}



extension URLResourceKey {
    
    /// The key for the file mode information of the file
    public static let fileModeKey: Self = .fileSecurityKey
    /// The key for the posix permission information of the file
    public static let posixPermissionKey: Self = .fileSecurityKey
    /// The key for the UID of the owner of the file
    public static let ownerUIDKey: Self = .fileSecurityKey
    /// The key for the GID of the owner of the file
    public static let ownerGIDKey: Self = .fileSecurityKey
    /// The key for the access control list of the file
    public static let accessControlListKey: Self = .fileSecurityKey
    
}
