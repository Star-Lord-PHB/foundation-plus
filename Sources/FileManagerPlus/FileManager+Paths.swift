import Foundation
import SystemPackage


extension FileManager {

    /// Get the Current Working Directory (CWD) as a FilePath
    public var currentDirectoryFilePath: FilePath {
        .init(self.currentDirectoryPath)
    }


    /// Get the Temporary Directory as a FilePath
    public var temporaryDirectoryFilePath: FilePath {
        self.temporaryDirectory.toFilePath()!
    }


    /// Get the Home Directory for the Current User as a FilePath
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public var homeDirectoryFilePathForCurrentUser: FilePath {
        self.homeDirectoryForCurrentUser.toFilePath()!
    }


    /// Get the Home Directory for the specified user as a FilePath
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public func homeDirectoryFilePath(forUser username: String) -> FilePath? {
        self.homeDirectory(forUser: username)?.toFilePath()
    }


    /// Returns an array of FilePaths for the specified common directory in the requested domains.
    /// - Parameters:
    ///   - directory: The search path directory. The supported values are described in FileManager.SearchPathDirectory.
    ///   - domain: The file system domain to search. The value for this parameter is one or more of 
    ///     the constants described in FileManager.SearchPathDomainMask.
    /// 
    /// - seealso: [`FileManager.urls(for:in:)`]
    /// 
    /// [`FileManager.urls(for:in:)`]: https://developer.apple.com/documentation/foundation/filemanager/1407726-urls
    public func paths(for directory: SearchPathDirectory, in domain: SearchPathDomainMask) -> [FilePath] {
        self.urls(for: directory, in: domain).compactMap { $0.toFilePath() }
    }


    /// Locates and optionally creates the specified common directory in a domain.
    /// - Parameters:
    ///   - directory: The search path directory. The supported values are described in FileManager.SearchPathDirectory.
    ///   - domain: The file system domain to search. The value for this parameter is one of the constants described in FileManager.SearchPathDomainMask. 
    ///     You should specify only one domain for your search and you may not specify the allDomainsMask constant for this parameter.
    ///   - path: The file URL used to determine the location of the returned URL. Only the volume of this parameter is used.
    ///     This parameter is ignored unless the directory parameter contains the value FileManager.SearchPathDirectory.itemReplacementDirectory 
    ///     and the domain parameter contains the value userDomainMask.
    ///   - shouldCreate: Whether to create the directory if it does not already exist.
    ///     When creating a temporary directory, this parameter is ignored and the directory is always created.
    /// 
    /// - seealso: [`FileManager.url(for:in:appropriateFor:create:)`]
    /// 
    /// [`FileManager.url(for:in:appropriateFor:create:)`]: https://developer.apple.com/documentation/foundation/filemanager/1407693-url
    public func path(
        for directory: SearchPathDirectory, 
        in domain: SearchPathDomainMask, 
        appropriateFor path: FilePath?, 
        create shouldCreate: Bool
    ) throws -> FilePath {
        try self.url(for: directory, in: domain, appropriateFor: path?.toURL(), create: shouldCreate).assertAsFilePath()
    }

}