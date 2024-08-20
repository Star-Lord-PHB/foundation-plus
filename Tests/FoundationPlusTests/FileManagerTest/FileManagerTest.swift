//
//  FileManagerTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Testing
@testable import FoundationPlus


@Suite
class FileManagerTest {
    
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
        let baseUrl: URL
        
        init(relativePath: String) throws {
            self.baseUrl = FileManager.default.temporaryDirectory.appending(path: relativePath)
            try manager.createDirectory(
                at: baseUrl,
                withIntermediateDirectories: true
            )
        }
        
        
        deinit {
            if (try? manager.contentsOfDirectory(atPath: baseUrl.compactPath()).isEmpty) == true {
                try? manager.removeItem(at: baseUrl)
            }
        }
        
    }
    
}



extension FileManagerTest.FileManagerTestCases {
    
    func makeTestingFileUrl(
        in baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = ""
    ) -> URL {
        let baseUrl = baseUrl ?? self.baseUrl
        return baseUrl.appending(path: name + suffix)
    }
    
    
    func withFile(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        content: Data = .init(),
        test: (URL, Data) async throws -> Void
    ) async throws {
        
        let fileUrl = makeTestingFileUrl(in: baseUrl, name: name, suffix: suffix)
        defer {
            try? manager.removeItem(at: fileUrl)
        }
        
        manager.createFile(atPath: fileUrl.compactPath(), contents: content)
        
        try await test(fileUrl, content)
        
    }
    
    
    func withFile(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        content: String,
        test: (URL, Data) async throws -> Void
    ) async throws {
        try await withFile(baseUrl: baseUrl, name: name, suffix: suffix, content: Data(content.utf8), test: test)
    }
    
    
    func withDirectory(
        baseUrl: URL? = nil,
        name: String = #function,
        suffix: String = "",
        test: (URL) async throws -> Void
    ) async throws {
        let url = makeTestingFileUrl(in: baseUrl, name: name, suffix: suffix)
        defer { try? manager.removeItem(at: url) }
        try manager.createDirectory(atPath: url.compactPath(), withIntermediateDirectories: true)
        try await test(url)
    }
    
    
    func withSymbolicLink(
        baseUrl: URL? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: Data = .init(),
        test: ([URL], Data) async throws -> Void
    ) async throws {
        
        precondition(depth >= 1, "the depth of symbolic link must be at least 1")
        
        let folder = (baseUrl ?? self.baseUrl).appending(path: baseName)
        defer { try? manager.removeItem(at: folder) }
        
        try manager.createDirectory(atPath: folder.compactPath(), withIntermediateDirectories: true)
        
        let urls = (0 ... depth).map {
            makeTestingFileUrl(in: folder, name: baseName, suffix: "-\($0)")
        }
        
        self.manager.createFile(atPath: urls.last!.compactPath(), contents: targetContent)
        
        for (src, dest) in zip(urls.reversed().dropFirst(), urls.reversed()) {
            try self.manager.createSymbolicLink(at: src, withDestinationURL: dest)
        }
        
        try await test(urls, targetContent)
        
    }
    
    
    func withSymbolicLink(
        baseUrl: URL? = nil,
        baseName: String = #function,
        depth: Int = 1,
        targetContent: String,
        test: ([URL], Data) async throws -> Void
    ) async throws {
        try await withSymbolicLink(
            baseUrl: baseUrl,
            baseName: baseName,
            depth: depth,
            targetContent: Data(targetContent.utf8),
            test: test
        )
    }
    
}
