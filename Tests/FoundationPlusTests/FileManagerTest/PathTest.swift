import Testing
import Foundation
@testable import FileManagerPlus


extension FileManagerTest {

    @Suite("Test FilePaths")
    final class PathTest: FileManagerTestCases {

        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/paths")
        }

        static let cwdPath: FilePath = .init(FileManager.default.currentDirectoryPath)
        
    }

}



extension FileManagerTest.PathTest {

    @Test(
        "Test Path -> URL Conversion",
        arguments: [
            ("test1/test2", .init(fileURLWithPath: "test1/test2")),
            ("/test1/test2", .init(fileURLWithPath: "/test1/test2"))
        ] as [(FilePath, URL)]
    )
    func path2UrlConversion1(_ path: FilePath, _ url: URL) async throws {
        #expect(path.toURL() == url)
    }


    @Test(
        "Test URL -> Path Conversion",
        arguments: [
            (.init(fileURLWithPath: "test1/test2"), cwdPath.appending("test1/test2")),
            (.init(fileURLWithPath: "/test1/test2"), "/test1/test2"),
        ] as [(URL, FilePath)]
    )
    func url2PathConversion1(_ url: URL, _ path: FilePath) async throws {
        #expect(url.toFilePath() == path)
    }


#if os(Windows)
    @Test(
        "Test Path -> URL Conversion",
        arguments: [
            ("C:/test1/test2", .init(filePath: "C:/test1/test2"))
        ] as [(FilePath, URL)]
    )
    func path2UrlConversion2(_ path: FilePath, _ url: URL) async throws {
        #expect(path.toURL() == url)
    }


    @Test(
        "Test URL -> Path Conversion",
        arguments: [
            (.init(filePath: "C:/test1/test2"), "C:/test1/test2")
        ] as [(URL, FilePath)]
    )
    func url2PathConversion2(_ url: URL, _ path: FilePath) async throws {
        print(url.path)
        #expect(url.toFilePath() == path)
    }
#endif

}