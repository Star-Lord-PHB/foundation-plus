//
//  URLResourcePair.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/8.
//

import Foundation
import UniformTypeIdentifiers


/// A wrapper that includes a `URLResourceKey` and a key path for fetching the corresponding
/// value from `URLResourceValues`
public struct URLResourcePair<K: KeyPath<URLResourceValues, T>, T>: @unchecked Sendable {
    
    public let key: URLResourceKey
    public let valueKeyPath: K
    
    public init(key: URLResourceKey, valueKeyPath: K) {
        self.key = key
        self.valueKeyPath = valueKeyPath
    }
    
}


public typealias URLReadOnlyResourcePair<T> = URLResourcePair<KeyPath<URLResourceValues, T>, T>
public typealias URLWritableResourcePair<T> = URLResourcePair<WritableKeyPath<URLResourceValues, T>, T>


extension URLResourcePair {
    
    public static var name: URLResourcePair<WritableKeyPath<URLResourceValues, String?>, String?> {
        .init(key: .nameKey, valueKeyPath: \.name)
    }
    public static var localizedName: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .localizedNameKey, valueKeyPath: \.localizedName)
    }
    public static var isRegularFile: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isRegularFileKey, valueKeyPath: \.isRegularFile)
    }
    public static var isDirectory: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isDirectoryKey, valueKeyPath: \.isDirectory)
    }
    public static var isSymbolicLink: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isSymbolicLinkKey, valueKeyPath: \.isSymbolicLink)
    }
    public static var isVolume: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isVolumeKey, valueKeyPath: \.isVolume)
    }
    public static var isPackage: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isPackageKey, valueKeyPath: \.isPackage)
    }
    @available(macOS 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *)
    public static var isApplication: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isApplicationKey, valueKeyPath: \.isApplication)
    }
#if os(macOS)
    @available(macOS 10.11, *)
    public static var applicationIsScriptable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .applicationIsScriptableKey, valueKeyPath: \.applicationIsScriptable)
    }
#endif
    public static var isSystemImmutable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isSystemImmutableKey, valueKeyPath: \.isSystemImmutable)
    }
    public static var isUserImmutable: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isUserImmutableKey, valueKeyPath: \.isUserImmutable)
    }
    public static var isHidden: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isHiddenKey, valueKeyPath: \.isHidden)
    }
    public static var hasHiddenExtension: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .hasHiddenExtensionKey, valueKeyPath: \.hasHiddenExtension)
    }
    public static var creationDate: URLResourcePair<WritableKeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .creationDateKey, valueKeyPath: \.creationDate)
    }
    public static var contentAccessDate: URLResourcePair<WritableKeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .contentAccessDateKey, valueKeyPath: \.contentAccessDate)
    }
    public static var contentModificationDate: URLResourcePair<WritableKeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .contentModificationDateKey, valueKeyPath: \.contentModificationDate)
    }
    public static var attributeModificationDate: URLResourcePair<KeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .attributeModificationDateKey, valueKeyPath: \.attributeModificationDate)
    }
    public static var linkCount: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .linkCountKey, valueKeyPath: \.linkCount)
    }
    public static var parentDirectory: URLResourcePair<KeyPath<URLResourceValues, URL?>, URL?> {
        .init(key: .parentDirectoryURLKey, valueKeyPath: \.parentDirectory)
    }
    public static var volume: URLResourcePair<KeyPath<URLResourceValues, URL?>, URL?> {
        .init(key: .volumeURLKey, valueKeyPath: \.volume)
    }
    @available(macOS, introduced: 10.10, deprecated: 100000.0, message: "Use .contentType instead")
    @available(iOS, introduced: 8.0, deprecated: 100000.0, message: "Use .contentType instead")
    @available(watchOS, introduced: 2.0, deprecated: 100000.0, message: "Use .contentType instead")
    @available(tvOS, introduced: 9.0, deprecated: 100000.0, message: "Use .contentType instead")
    @available(visionOS, introduced: 1.0, deprecated: 100000.0, message: "Use .contentType instead")
    public static var typeIdentifier: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .typeIdentifierKey, valueKeyPath: \.typeIdentifier)
    }
    public static var localizedTypeDescription: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .localizedTypeDescriptionKey, valueKeyPath: \.localizedTypeDescription)
    }
    public static var labelNumber: URLResourcePair<WritableKeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .labelNumberKey, valueKeyPath: \.labelNumber)
    }
    public static var localizedLabel: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .localizedLabelKey, valueKeyPath: \.localizedLabel)
    }
    @available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
    public static var fileIdentifier: URLResourcePair<KeyPath<URLResourceValues, UInt64?>, UInt64?> {
        .init(key: .fileIdentifierKey, valueKeyPath: \.fileIdentifier)
    }
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var fileContentIdentifier: URLResourcePair<KeyPath<URLResourceValues, Int64?>, Int64?> {
        .init(key: .fileContentIdentifierKey, valueKeyPath: \.fileContentIdentifier)
    }
    public static var preferredIOBlockSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .preferredIOBlockSizeKey, valueKeyPath: \.preferredIOBlockSize)
    }
    public static var isReadable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isReadableKey, valueKeyPath: \.isReadable)
    }
    public static var isWritable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isWritableKey, valueKeyPath: \.isWritable)
    }
    public static var isExecutable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isExecutableKey, valueKeyPath: \.isExecutable)
    }
    public static var fileSecurity: URLResourcePair<WritableKeyPath<URLResourceValues, NSFileSecurity?>, NSFileSecurity?> {
        .init(key: .fileSecurityKey, valueKeyPath: \.fileSecurity)
    }
    public static var isExcludedFromBackup: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isExcludedFromBackupKey, valueKeyPath: \.isExcludedFromBackup)
    }
    public static var path: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .pathKey, valueKeyPath: \.path)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var canonicalPath: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .canonicalPathKey, valueKeyPath: \.canonicalPath)
    }
    public static var isMountTrigger: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isMountTriggerKey, valueKeyPath: \.isMountTrigger)
    }
    @available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
    public static var documentIdentifier: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .documentIdentifierKey, valueKeyPath: \.documentIdentifier)
    }
    @available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
    public static var addedToDirectoryDate: URLResourcePair<KeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .addedToDirectoryDateKey, valueKeyPath: \.addedToDirectoryDate)
    }
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var mayHaveExtendedAttributes: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .mayHaveExtendedAttributesKey, valueKeyPath: \.mayHaveExtendedAttributes)
    }
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var isPurgeable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isPurgeableKey, valueKeyPath: \.isPurgeable)
    }
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var isSparse: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isSparseKey, valueKeyPath: \.isSparse)
    }
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var mayShareFileContent: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .mayShareFileContentKey, valueKeyPath: \.mayShareFileContent)
    }
    public static var fileResourceType: URLResourcePair<KeyPath<URLResourceValues, URLFileResourceType?>, URLFileResourceType?> {
        .init(key: .fileResourceTypeKey, valueKeyPath: \.fileResourceType)
    }
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    public static var directoryEntryCount: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .directoryEntryCountKey, valueKeyPath: \.directoryEntryCount)
    }
    public static var volumeLocalizedFormatDescription: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeLocalizedFormatDescriptionKey, valueKeyPath: \.volumeLocalizedFormatDescription)
    }
    public static var volumeTotalCapacity: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .volumeTotalCapacityKey, valueKeyPath: \.volumeTotalCapacity)
    }
    public static var volumeAvailableCapacity: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .volumeAvailableCapacityKey, valueKeyPath: \.volumeAvailableCapacity)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var volumeAvailableCapacityForImportantUsage: URLResourcePair<KeyPath<URLResourceValues, Int64?>, Int64?> {
        .init(key: .volumeAvailableCapacityForImportantUsageKey, valueKeyPath: \.volumeAvailableCapacityForImportantUsage)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var volumeAvailableCapacityForOpportunisticUsage: URLResourcePair<KeyPath<URLResourceValues, Int64?>, Int64?> {
        .init(key: .volumeAvailableCapacityForOpportunisticUsageKey, valueKeyPath: \.volumeAvailableCapacityForOpportunisticUsage)
    }
    public static var volumeResourceCount: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .volumeResourceCountKey, valueKeyPath: \.volumeResourceCount)
    }
    public static var volumeSupportsPersistentIDs: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsPersistentIDsKey, valueKeyPath: \.volumeSupportsPersistentIDs)
    }
    public static var volumeSupportsSymbolicLinks: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsSymbolicLinksKey, valueKeyPath: \.volumeSupportsSymbolicLinks)
    }
    public static var volumeSupportsHardLinks: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsHardLinksKey, valueKeyPath: \.volumeSupportsHardLinks)
    }
    public static var volumeSupportsJournaling: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsJournalingKey, valueKeyPath: \.volumeSupportsJournaling)
    }
    public static var volumeIsJournaling: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsJournalingKey, valueKeyPath: \.volumeIsJournaling)
    }
    public static var volumeSupportsSparseFiles: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsSparseFilesKey, valueKeyPath: \.volumeSupportsSparseFiles)
    }
    public static var volumeSupportsZeroRuns: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsZeroRunsKey, valueKeyPath: \.volumeSupportsZeroRuns)
    }
    public static var volumeSupportsCaseSensitiveNames: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsCaseSensitiveNamesKey, valueKeyPath: \.volumeSupportsCaseSensitiveNames)
    }
    public static var volumeSupportsCasePreservedNames: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsCasePreservedNamesKey, valueKeyPath: \.volumeSupportsCasePreservedNames)
    }
    public static var volumeSupportsRootDirectoryDates: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsRootDirectoryDatesKey, valueKeyPath: \.volumeSupportsRootDirectoryDates)
    }
    public static var volumeSupportsVolumeSizes: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsVolumeSizesKey, valueKeyPath: \.volumeSupportsVolumeSizes)
    }
    public static var volumeSupportsRenaming: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsRenamingKey, valueKeyPath: \.volumeSupportsRenaming)
    }
    public static var volumeSupportsAdvisoryFileLocking: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsAdvisoryFileLockingKey, valueKeyPath: \.volumeSupportsAdvisoryFileLocking)
    }
    public static var volumeSupportsExtendedSecurity: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsExtendedSecurityKey, valueKeyPath: \.volumeSupportsExtendedSecurity)
    }
    public static var volumeIsBrowsable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsBrowsableKey, valueKeyPath: \.volumeIsBrowsable)
    }
    public static var volumeMaximumFileSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .volumeMaximumFileSizeKey, valueKeyPath: \.volumeMaximumFileSize)
    }
    public static var volumeIsEjectable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsEjectableKey, valueKeyPath: \.volumeIsEjectable)
    }
    public static var volumeIsRemovable: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsRemovableKey, valueKeyPath: \.volumeIsRemovable)
    }
    public static var volumeIsInternal: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsInternalKey, valueKeyPath: \.volumeIsInternal)
    }
    public static var volumeIsAutomounted: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsAutomountedKey, valueKeyPath: \.volumeIsAutomounted)
    }
    public static var volumeIsLocal: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsLocalKey, valueKeyPath: \.volumeIsLocal)
    }
    public static var volumeIsReadOnly: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsReadOnlyKey, valueKeyPath: \.volumeIsReadOnly)
    }
    public static var volumeCreationDate: URLResourcePair<KeyPath<URLResourceValues, Date?>, Date?> {
        .init(key: .volumeCreationDateKey, valueKeyPath: \.volumeCreationDate)
    }
    public static var volumeURLForRemounting: URLResourcePair<KeyPath<URLResourceValues, URL?>, URL?> {
        .init(key: .volumeURLForRemountingKey, valueKeyPath: \.volumeURLForRemounting)
    }
    public static var volumeUUIDString: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeUUIDStringKey, valueKeyPath: \.volumeUUIDString)
    }
    public static var volumeName: URLResourcePair<WritableKeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeNameKey, valueKeyPath: \.volumeName)
    }
    public static var volumeLocalizedName: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeLocalizedNameKey, valueKeyPath: \.volumeLocalizedName)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeIsEncrypted: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsEncryptedKey, valueKeyPath: \.volumeIsEncrypted)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeIsRootFileSystem: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeIsRootFileSystemKey, valueKeyPath: \.volumeIsRootFileSystem)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeSupportsCompression: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsCompressionKey, valueKeyPath: \.volumeSupportsCompression)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeSupportsFileCloning: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsFileCloningKey, valueKeyPath: \.volumeSupportsFileCloning)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeSupportsSwapRenaming: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsSwapRenamingKey, valueKeyPath: \.volumeSupportsSwapRenaming)
    }
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public static var volumeSupportsExclusiveRenaming: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsExclusiveRenamingKey, valueKeyPath: \.volumeSupportsExclusiveRenaming)
    }
    @available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    public static var volumeSupportsImmutableFiles: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsImmutableFilesKey, valueKeyPath: \.volumeSupportsImmutableFiles)
    }
    @available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    public static var volumeSupportsAccessPermissions: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .volumeSupportsAccessPermissionsKey, valueKeyPath: \.volumeSupportsAccessPermissions)
    }
    @available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
    public static var volumeTypeName: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeTypeNameKey, valueKeyPath: \.volumeTypeName)
    }
    @available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
    public static var volumeSubtype: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .volumeSubtypeKey, valueKeyPath: \.volumeSubtype)
    }
    @available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
    public static var volumeMountFromLocation: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .volumeMountFromLocationKey, valueKeyPath: \.volumeMountFromLocation)
    }
    public static var isUbiquitousItem: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isUbiquitousItemKey, valueKeyPath: \.isUbiquitousItem)
    }
    public static var ubiquitousItemHasUnresolvedConflicts: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemHasUnresolvedConflictsKey, valueKeyPath: \.ubiquitousItemHasUnresolvedConflicts)
    }
    public static var ubiquitousItemIsDownloading: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemIsDownloadingKey, valueKeyPath: \.ubiquitousItemIsDownloading)
    }
    public static var ubiquitousItemIsUploaded: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemIsUploadedKey, valueKeyPath: \.ubiquitousItemIsUploaded)
    }
    public static var ubiquitousItemIsUploading: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemIsUploadingKey, valueKeyPath: \.ubiquitousItemIsUploading)
    }
    public static var ubiquitousItemDownloadingStatus: URLResourcePair<KeyPath<URLResourceValues, URLUbiquitousItemDownloadingStatus?>, URLUbiquitousItemDownloadingStatus?> {
        .init(key: .ubiquitousItemDownloadingStatusKey, valueKeyPath: \.ubiquitousItemDownloadingStatus)
    }
    public static var ubiquitousItemDownloadingError: URLResourcePair<KeyPath<URLResourceValues, NSError?>, NSError?> {
        .init(key: .ubiquitousItemDownloadingErrorKey, valueKeyPath: \.ubiquitousItemDownloadingError)
    }
    public static var ubiquitousItemUploadingError: URLResourcePair<KeyPath<URLResourceValues, NSError?>, NSError?> {
        .init(key: .ubiquitousItemUploadingErrorKey, valueKeyPath: \.ubiquitousItemUploadingError)
    }
    @available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
    public static var ubiquitousItemDownloadRequested: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemDownloadRequestedKey, valueKeyPath: \.ubiquitousItemDownloadRequested)
    }
    @available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
    public static var ubiquitousItemContainerDisplayName: URLResourcePair<KeyPath<URLResourceValues, String?>, String?> {
        .init(key: .ubiquitousItemContainerDisplayNameKey, valueKeyPath: \.ubiquitousItemContainerDisplayName)
    }
    @available(macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5, *)
    public static var ubiquitousItemIsExcludedFromSync: URLResourcePair<WritableKeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemIsExcludedFromSyncKey, valueKeyPath: \.ubiquitousItemIsExcludedFromSync)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var ubiquitousItemIsShared: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .ubiquitousItemIsSharedKey, valueKeyPath: \.ubiquitousItemIsShared)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var ubiquitousSharedItemCurrentUserRole: URLResourcePair<KeyPath<URLResourceValues, URLUbiquitousSharedItemRole?>, URLUbiquitousSharedItemRole?> {
        .init(key: .ubiquitousSharedItemCurrentUserRoleKey, valueKeyPath: \.ubiquitousSharedItemCurrentUserRole)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var ubiquitousSharedItemCurrentUserPermissions: URLResourcePair<KeyPath<URLResourceValues, URLUbiquitousSharedItemPermissions?>, URLUbiquitousSharedItemPermissions?> {
        .init(key: .ubiquitousSharedItemCurrentUserPermissionsKey, valueKeyPath: \.ubiquitousSharedItemCurrentUserPermissions)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var ubiquitousSharedItemOwnerNameComponents: URLResourcePair<KeyPath<URLResourceValues, PersonNameComponents?>, PersonNameComponents?> {
        .init(key: .ubiquitousSharedItemOwnerNameComponentsKey, valueKeyPath: \.ubiquitousSharedItemOwnerNameComponents)
    }
    @available(macOS 10.13, iOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var ubiquitousSharedItemMostRecentEditorNameComponents: URLResourcePair<KeyPath<URLResourceValues, PersonNameComponents?>, PersonNameComponents?> {
        .init(key: .ubiquitousSharedItemMostRecentEditorNameComponentsKey, valueKeyPath: \.ubiquitousSharedItemMostRecentEditorNameComponents)
    }
    @available(macOS 11.0, iOS 9.0, *)
    public static var fileProtection: URLResourcePair<KeyPath<URLResourceValues, URLFileProtection?>, URLFileProtection?> {
        .init(key: .fileProtectionKey, valueKeyPath: \.fileProtection)
    }
    public static var fileSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .fileSizeKey, valueKeyPath: \.fileSize)
    }
    public static var fileAllocatedSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .fileAllocatedSizeKey, valueKeyPath: \.fileAllocatedSize)
    }
    public static var totalFileSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .totalFileSizeKey, valueKeyPath: \.totalFileSize)
    }
    public static var totalFileAllocatedSize: URLResourcePair<KeyPath<URLResourceValues, Int?>, Int?> {
        .init(key: .totalFileAllocatedSizeKey, valueKeyPath: \.totalFileAllocatedSize)
    }
    public static var isAliasFile: URLResourcePair<KeyPath<URLResourceValues, Bool?>, Bool?> {
        .init(key: .isAliasFileKey, valueKeyPath: \.isAliasFile)
    }
    
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public static var contentType: URLResourcePair<KeyPath<URLResourceValues, UTType?>, UTType?> {
        .init(key: .contentTypeKey, valueKeyPath: \.contentType)
    }
    
}


extension URLResourcePair {
    
    public static var fileMode: URLWritableResourcePair<UInt16?> {
        .init(key: .fileModeKey, valueKeyPath: \.fileMode)
    }
    public static var posixPermission: URLResourcePair<WritableKeyPath<URLResourceValues, UInt16?>, UInt16?> {
        .init(key: .posixPermissionKey, valueKeyPath: \.posixPermission)
    }
    public static var ownerUID: URLResourcePair<WritableKeyPath<URLResourceValues, UInt32?>, UInt32?> {
        .init(key: .ownerUIDKey, valueKeyPath: \.ownerUID)
    }
    public static var ownerGID: URLResourcePair<WritableKeyPath<URLResourceValues, UInt32?>, UInt32?> {
        .init(key: .ownerGIDKey, valueKeyPath: \.ownerGID)
    }
    public static var accessControlList: URLResourcePair<WritableKeyPath<URLResourceValues, acl_t?>, acl_t?> {
        .init(key: .accessControlListKey, valueKeyPath: \.accessControlList)
    }
    
}
