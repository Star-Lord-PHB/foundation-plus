#if os(Windows)

import WinSDK


extension String {

    func withLPCWSTR<Result>(_ body: (LPCWSTR) throws -> Result) rethrows -> Result {

        try self.withCString(encodedAs: UTF16.self) { cString in
            try body(cString)
        }

    }


    var lpcwstr: [WCHAR] {
        self.utf16.map { $0 as WCHAR } + [0]
    }

}

#endif