import Foundation
import SystemPackage


extension FileManager {

    public var currentDirectoryFilePath: FilePath {
        .init(self.currentDirectoryPath)
    }


    public var temporaryDirectoryFilePath: FilePath {
        self.temporaryDirectory.toFilePath()!
    }


    public func paths(for directory: SearchPathDirectory, in domain: SearchPathDomainMask) -> [FilePath] {
        self.urls(for: directory, in: domain).compactMap { $0.toFilePath() }
    }


    public func path(
        for directory: SearchPathDirectory, 
        in domain: SearchPathDomainMask, 
        appropriateFor path: FilePath?, 
        create shouldCreate: Bool
    ) throws -> FilePath {
        try self.url(for: directory, in: domain, appropriateFor: path?.toURL(), create: shouldCreate).assertAsFilePath()
    }

}