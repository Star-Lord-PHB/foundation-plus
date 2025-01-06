#if os(Windows)

import WinSDK
import Foundation
import SystemPackage
import FoundationPlusEssential


enum WindowsFileUtils {

    static func withSecurityDescriptor<R>(ofItemAt path: FilePath, operation: (PSECURITY_DESCRIPTOR) throws -> R) throws -> R {
        
        var lengthNeeded: DWORD = 0

        guard 
            GetFileSecurityW(path.toLpwstr(), SECURITY_INFORMATION(DACL_SECURITY_INFORMATION | OWNER_SECURITY_INFORMATION), nil, 0, &lengthNeeded) == false,
            GetLastError() == ERROR_INSUFFICIENT_BUFFER
        else {
            throw CocoaError.lastWin32Error(path: path, reading: true)
        }

        let securityDescriptor: PSECURITY_DESCRIPTOR = .init(UnsafeMutablePointer<UInt8>.allocate(capacity: Int(lengthNeeded)))
        defer { securityDescriptor.deallocate() }

        guard GetFileSecurityW(path.toLpwstr(), SECURITY_INFORMATION(DACL_SECURITY_INFORMATION | OWNER_SECURITY_INFORMATION), securityDescriptor, lengthNeeded, &lengthNeeded) else {
            throw CocoaError.lastWin32Error(path: path, reading: true)
        }

        return try operation(securityDescriptor)

    }


    static func getOwnerSid(from securityDescriptor: PSECURITY_DESCRIPTOR) throws(WindowsError) -> String {

        var owner: PSID? = nil
        var ownerDefaulted: WindowsBool = false
        var ownerSidString: LPWSTR? = nil

        guard GetSecurityDescriptorOwner(securityDescriptor, &owner, &ownerDefaulted) else {
            throw WindowsError.fromLastError()
        }
        guard ConvertSidToStringSidW(owner, &ownerSidString), let ownerSidString else {
            throw WindowsError.fromLastError()
        }

        defer { LocalFree(ownerSidString) }

        return String(decodingCString: ownerSidString, as: UTF16.self)

    }


    static func getACL(from securityDescriptor: PSECURITY_DESCRIPTOR) throws(WindowsError) -> [(type: Int32, ace: PVOID)]? {

        var dacl: PACL? = nil
        var daclPresent: WindowsBool = false
        var daclDefaulted: WindowsBool = false

        guard GetSecurityDescriptorDacl(securityDescriptor, &daclPresent, &dacl, &daclDefaulted) else {
            throw WindowsError.fromLastError()
        }

        guard daclPresent.boolValue else { return nil }
        guard let dacl else { return [] }

        return try (0 ..< dacl.pointee.AceCount).map { aceIndex throws(WindowsError) in
            
            var ace: PVOID? = nil
            guard GetAce(dacl, DWORD(aceIndex), &ace), let ace else {
                throw WindowsError.fromLastError()
            }

            let aceHeader = ace.assumingMemoryBound(to: ACE_HEADER.self).pointee

            return (.init(aceHeader.AceType), ace)

        }.compactMap { $0 }

    }


    static func withFileHandle<R>(
        ofItemAt path: FilePath, 
        accessMode: WindowsFileAccessMode = .genericRead,
        shareMode: WindowsFileShareMode = .shareRead,
        createMode: WindowsFileCreationMode = .openExisting,
        flagsAndAttributes: WindowsFileFlagsAndAttributes = .fileAttributeOptions.normal,
        operation: (HANDLE) throws -> R
    ) throws -> R {

        let fileDescriptor = CreateFileW(
            path.toLpwstr(),
            accessMode.rawValue,
            shareMode.rawValue,
            nil,
            createMode.rawValue,
            flagsAndAttributes.rawValue,
            nil
        )

        guard let fileDescriptor, fileDescriptor != INVALID_HANDLE_VALUE else {
            throw WindowsError.fromLastError()
        }

        defer { CloseHandle(fileDescriptor) }

        return try operation(fileDescriptor)

    }


    static func getFileInformation(from fileHandle: HANDLE) throws -> BY_HANDLE_FILE_INFORMATION {

        var fileInformation = BY_HANDLE_FILE_INFORMATION()
        guard GetFileInformationByHandle(fileHandle, &fileInformation) else {
            throw WindowsError.fromLastError()
        }

        return fileInformation

    }


    static func interceptWindowsErrorAsCocorError<R>(path: FilePath, reading: Bool, operation: () throws -> R) throws -> R {
        do {
            return try operation()
        } catch let error as WindowsError {
            throw CocoaError.win32Error(path: path, win32Error: error, reading: reading)
        }
    }

}

#endif