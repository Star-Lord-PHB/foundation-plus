#if os(Windows)

import WinSDK
import Foundation

public struct WindowsError: LocalizedError {

    public let code: DWORD
    public let message: String

    public var errorDescription: String? { message }

    public init(code: DWORD) {
        self.code = code
        self.message = Self.getErrorMessage(from: code)
    }


    public static var errorDomain: String {
        "NSWin32ErrorDomain"
    }
    
}


extension WindowsError {

    public static func fromLastError() -> WindowsError {
        .init(code: GetLastError())
    }


    public static func getErrorMessage(from code: DWORD) -> String {

        var messageBuffer: LPWSTR? = nil 

        let size = withUnsafeMutablePointer(to: &messageBuffer) { ptr in 

            // let bufferPtr = unsafeBitCast(ptr, to: LPWSTR.self)

            return ptr.withMemoryRebound(to: WCHAR.self, capacity: 1) { bufferPtr in

                FormatMessageW(
                    DWORD(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS),
                    nil,
                    code,
                    DWORD(LANG_NEUTRAL),
                    bufferPtr,
                    0,
                    nil
                )

            }

            // return FormatMessageW(
            //     DWORD(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS),
            //     nil,
            //     code,
            //     DWORD(LANG_NEUTRAL),
            //     bufferPtr,
            //     0,
            //     nil
            // )

        }
        
        defer {
            if let messageBuffer {
                LocalFree(messageBuffer)
            }
        }
        
        if size > 0, let messageBuffer {
            return String(decodingCString: messageBuffer, as: UTF16.self)
        } else {
            return "Unknown error"
        }

    }

}

#endif