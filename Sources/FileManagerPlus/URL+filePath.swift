import Foundation
import SystemPackage
import FoundationPlusEssential
#if canImport(WinSDK)
import WinSDK
#endif


extension URL {

    /// Convert the URL to a FilePath
    /// 
    /// - Returns: The FilePath representation of the URL. 
    /// If the url cannot be interpreted as a file url, return nil
    public func toFilePath() -> FilePath? {
        guard self.isFileURL else { return nil  }
        return .init(self.compatPath(percentEncoded: false))
    }


    /// Convert the URL to a FilePath
    /// 
    /// - Returns: The FilePath representation of the URL. 
    /// - Throws: If the url cannot be interpreted as a file url, 
    /// throw an `URLError` with `unsupportedURL` code
    public func assertAsFilePath() throws -> FilePath {
        guard let path = self.toFilePath() else {
            throw URLError(
                .unsupportedURL, 
                userInfo: [NSURLErrorKey: self, NSLocalizedDescriptionKey: "The url is not a file url"]
            )
        }
        return path
    }

#if os(Windows)
    func toLpwstr() -> [WCHAR] {
        self.path(percentEncoded: false).lpcwstr
    }
#endif

}


extension FilePath {

    /// Convert the FilePath to a URL
    public func toURL() -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            .init(filePath: self.string)
        } else {
            .init(fileURLWithPath: self.string)
        }
    }

#if os(Windows) 
    func toLpwstr() -> [WCHAR] {
        self.string.lpcwstr
    }
#endif

}