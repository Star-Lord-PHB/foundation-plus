import Foundation
import SystemPackage
import FoundationPlusEssential
#if canImport(WinSDK)
import WinSDK
#endif

extension URL {

    func toFilePath() -> FilePath? {
        guard self.isFileURL else { return nil  }
        return .init(self.compatPath(percentEncoded: false))
    }

    func assertAsFilePath() throws -> FilePath {
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

    func toURL() -> URL {
        .init(filePath: self.string)
    }

#if os(Windows) 
    func toLpwstr() -> [WCHAR] {
        self.string.lpcwstr
    }
#endif

}