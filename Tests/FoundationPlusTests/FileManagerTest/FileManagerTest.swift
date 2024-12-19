//
//  FileManagerTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Testing
import SystemPackage
import Foundation


@Suite
final class FileManagerTest {
    
    /// A helper super class for tests related to `FileManager`.
    ///
    /// Test suites for `FileManager` can inherit this class to automatically have things setup
    /// and get access to some useful methods, which includes:
    ///
    /// * `manager` property: quick access to a `FileManager` instance (which is actually just
    /// `FileManager.default`
    /// * `baseUrl` property: quick access to the url of a folder created for any operations.
    /// Any operations related to files should be done within this folder
    /// * `makeTestingFileUrl` method: get the url of the file for the current test case
    /// (does not guarantee that the file exist)
    /// * `withFile` method: create a file for the current test case and automatically remove it
    /// at the end
    /// * Folders for each test suite will be created automatically. And if all the test cases
    /// guarantee to remove the file they use, the folder will be removed at the end as well
    ///
    /// After inherit this class, REMEMBER to define an initializer with no argument and call
    /// the `super.init` with the relative path for the test suite
    ///
    /// ```swift
    /// class TestSuite: FileManagerTestCases {
    ///
    ///     init() throws {
    ///         try super.init(relativePath: "foundation_plus/file_manager/test_suite")
    ///     }
    ///
    ///     @Test
    ///     func test1() async throws {
    ///         try await withFile(content: "content") { url, content in
    ///             // some test operations
    ///         }
    ///     }
    ///
    /// }
    /// ```
    class FileManagerTestCases {
        
        var manager: FileManager { .default }
        let basePath: FilePath
        var baseUrl: URL {
            .init(filePath: basePath.string)
        }

        private static let lock: NSLock = .init()
        
        init(relativePath: String) throws {
            self.basePath = .init(FileManager.default.temporaryDirectory.appending(path: relativePath).path) 
            try Self.lock.withLock {
                try manager.createDirectory(atPath: basePath.string, withIntermediateDirectories: true)
            }
        }
        
    }
    
}



extension FileManagerTest.FileManagerTestCases {
    
    func makeTestingFilePath(
        in basePath: FilePath? = nil,
        name: String = #function,
        suffix: String = ""
    ) -> FilePath {
        let name = name.replacingOccurrences(of: ":", with: "-")
        let basePath = basePath ?? self.basePath
        return basePath.appending(name + suffix)
    }


    func makeTestingFileUrl(
        in baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = ""
    ) -> URL {
        .init(filePath: makeTestingFilePath(in: .init((baseUrl ?? self.baseUrl).path), name: name, suffix: suffix).string)
    }


    func withFileAtPath(
        basePath: FilePath? = nil,
        name: String = #function,
        suffix: String = "",
        content: Data = .init(),
        test: (FilePath, Data) async throws -> Void
    ) async throws {
        
        let filePath = makeTestingFilePath(in: basePath, name: name, suffix: suffix)
        defer {
            try? manager.removeItem(atPath: filePath.string)
        }
        
        let _ = manager.createFile(atPath: filePath.string, contents: content)
        
        try await test(filePath, content)
        
    }


    func withFileAtPath(
        basePath: FilePath? = nil,
        name: String = #function,
        suffix: String = "",
        content: String,
        test: (FilePath, Data) async throws -> Void
    ) async throws {
        try await self.withFileAtPath(basePath: basePath, name: name, suffix: suffix, content: Data(content.utf8), test: test)
    }
    
    
    func withFileAtUrl(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        content: Data = .init(),
        test: (URL, Data) async throws -> Void
    ) async throws {
        
        let fileUrl = makeTestingFileUrl(in: baseUrl, name: name, suffix: suffix)
        defer {
            try? manager.removeItem(atPath: fileUrl.path)
        }
        
        let _ = manager.createFile(atPath: fileUrl.compatPath(), contents: content)
        
        try await test(fileUrl, content)
        
    }
    
    
    func withFileAtUrl(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        content: String,
        test: (URL, Data) async throws -> Void
    ) async throws {
        try await withFileAtUrl(baseUrl: baseUrl, name: name, suffix: suffix, content: Data(content.utf8), test: test)
    }


    func withDirectoryAtPath(
        basePath: FilePath? = nil,
        name: String = #function,
        suffix: String = "",
        test: (FilePath) async throws -> Void
    ) async throws {
        let path = makeTestingFilePath(in: basePath, name: name, suffix: suffix)
        defer { try? manager.removeItem(atPath: path.string) }
        try manager.createDirectory(atPath: path.string, withIntermediateDirectories: true)
        try await test(path)
    }
    
    
    func withDirectoryAtUrl(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        test: (URL) async throws -> Void
    ) async throws {
        let url = makeTestingFileUrl(in: baseUrl, name: name, suffix: suffix)
        defer { try? manager.removeItem(at: url) }
        try manager.createDirectory(atPath: url.compatPath(), withIntermediateDirectories: true)
        try await test(url)
    }


    func withSymbolicLinkAtPath(
        basePath: FilePath? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: Data = .init(),
        test: ([FilePath], Data) async throws -> Void
    ) async throws {
        
        precondition(depth >= 1, "the depth of symbolic link must be at least 1")
        
        let folder = (basePath ?? self.basePath).appending(baseName)
        defer { try? manager.removeItem(atPath: folder.string) }
        
        try manager.createDirectory(atPath: folder.string, withIntermediateDirectories: true)
        
        let paths = (0 ... depth).map {
            makeTestingFilePath(in: folder, name: baseName, suffix: "-\($0)")
        }
        
        let _ = self.manager.createFile(atPath: paths.last!.string, contents: targetContent)
        
        for (src, dest) in zip(paths.reversed().dropFirst(), paths.reversed()) {
            try self.manager.createSymbolicLink(atPath: src.string, withDestinationPath: dest.string)
        }
        
        try await test(paths, targetContent)
        
    }


    func withSymbolicLinkAtPath(
        basePath: FilePath? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: String,
        test: ([FilePath], Data) async throws -> Void
    ) async throws {
        try await withSymbolicLinkAtPath(
            basePath: basePath,
            baseName: baseName,
            depth: depth,
            targetContent: Data(targetContent.utf8),
            test: test
        )
    }
    
    
    func withSymbolicLinkAtUrl(
        baseUrl: URL? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: Data = .init(),
        test: ([URL], Data) async throws -> Void
    ) async throws {
        
        precondition(depth >= 1, "the depth of symbolic link must be at least 1")
        
        let folder = (baseUrl ?? self.baseUrl).appending(path: baseName)
        defer { try? manager.removeItem(at: folder) }
        
        try manager.createDirectory(atPath: folder.compatPath(), withIntermediateDirectories: true)
        
        let urls = (0 ... depth).map {
            makeTestingFileUrl(in: folder, name: baseName, suffix: "-\($0)")
        }
        
        let _ = self.manager.createFile(atPath: urls.last!.compatPath(), contents: targetContent)
        
        for (src, dest) in zip(urls.reversed().dropFirst(), urls.reversed()) {
            try self.manager.createSymbolicLink(at: src, withDestinationURL: dest)
        }
        
        try await test(urls, targetContent)
        
    }
    
    
    func withSymbolicLinkAtUrl(
        baseUrl: URL? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: String,
        test: ([URL], Data) async throws -> Void
    ) async throws {
        try await withSymbolicLinkAtUrl(
            baseUrl: baseUrl,
            baseName: baseName,
            depth: depth,
            targetContent: Data(targetContent.utf8),
            test: test
        )
    }
    
}


extension FileManagerTest.FileManagerTestCases {

    func contentOfFile(at path: FilePath) throws -> Data {
        try Data(contentsOf: .init(filePath: path.string))
    }


    func contentOfFile(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }

}


extension FileManagerTest.FileManagerTestCases {
    enum FileStructure {
        case file(name: String, content: Data?)
        case directory(name: String, [FileStructure])
        case symbolicLink(name: String, target: FilePath)
        var name: String {
            switch self {
                case let .file(name, _), let .directory(name, _), let .symbolicLink(name, _): name
            }
        }
        static func file(name: String) -> FileStructure {
            .file(name: name, content: nil)
        }
        static func file(name: String, content: String) -> FileStructure {
            .file(name: name, content: Data(content.utf8))
        }
        static func directory(name: String) -> FileStructure {
            .directory(name: name, [])
        }
    }
    enum FileTree {
        case file(path: FilePath, content: Data)
        case directory(path: FilePath, [FileTree])
        case symbolicLink(path: FilePath, target: FilePath)
        var name: String {
            switch self {
                case let .file(path, _), let .directory(path, _), let .symbolicLink(path, _): path.lastComponent?.string ?? ""
            }
        }
        var path: FilePath {
            switch self {
                case let .file(path, _), let .directory(path, _), let .symbolicLink(path, _): path
            }
        }
        var content: Data {
            switch self {
                case let .file(_, content): content
                default: fatalError("Not a file")
            }
        }
        var target: FilePath {
            switch self {
                case let .symbolicLink(_, target): target
                default: fatalError("Not a symbolic link")
            }
        }
    }
}


extension FileManagerTest.FileManagerTestCases.FileTree {

    subscript(_ path: String) -> Self {
        var currentItem = self 
        for component in path.split(separator: "/") {
            guard case let .directory(_, children) = currentItem else {
                fatalError("Not a directory")
            }
            guard let child = children.first(where: { $0.name == component }) else {
                fatalError("No such file or directory")
            }
            currentItem = child
        }
        return currentItem
    }

}


extension FileManagerTest.FileManagerTestCases {

    func withFileTree(_ structure: [FileStructure], baseName: String = #function, test: (FileTree) async throws -> Void) async throws {

        let baseDir = basePath.appending(baseName.replacingOccurrences(of: ":", with: "-"))
        try manager.createDirectory(atPath: baseDir.string, withIntermediateDirectories: true)
        defer { try? manager.removeItem(atPath: baseDir.string) }

        func createFileTree(_ tree: FileStructure, currentDir: FilePath) throws -> FileTree {

            switch tree {
                case let .file(name, content):
                    let path = currentDir.appending(name.replacingOccurrences(of: ":", with: "-"))
                    let _ = manager.createFile(atPath: path.string, contents: content ?? .init())
                    return .file(path: path, content: content ?? .init())
                case let .symbolicLink(name, target): 
                    let path = currentDir.appending(name.replacingOccurrences(of: ":", with: "-"))
                    try manager.createSymbolicLink(atPath: path.string, withDestinationPath: target.string)
                    return .symbolicLink(path: path, target: target)
                case let .directory(name, children):
                    let path = currentDir.appending(name.replacingOccurrences(of: ":", with: "-"))
                    try manager.createDirectory(atPath: path.string, withIntermediateDirectories: true)
                    let treeChildren = try children.map { try createFileTree($0, currentDir: path) }
                    return .directory(path: path, treeChildren)
            }

        }

        let treeChildren = try structure.map { try createFileTree($0, currentDir: baseDir) }

        try await test(.directory(path: baseDir, treeChildren))

    }

}