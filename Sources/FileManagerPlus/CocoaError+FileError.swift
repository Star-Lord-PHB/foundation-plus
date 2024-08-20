//
//  CocoaError.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/13.
//

import Foundation


extension CocoaError {
    
    /// Create a CocoaError specific for errors related to files
    /// - Parameters:
    ///   - code: The error code
    ///   - url: The url that cause the error
    ///   - description: Description of the error
    ///   - underlyingError: Some underlying error, if any (e.g.: a POSIXError)
    ///   - otherUserInfo: Some other required user info
    public static func fileError(
        _ code: Code,
        url: URL,
        description: String = "",
        underlyingError: (any Error)? = nil,
        otherUserInfo: [String: Any] = [:]
    ) -> Self {
        .init(
            code,
            userInfo: [
                NSURLErrorKey: url,
                NSLocalizedDescriptionKey: description,
                NSUnderlyingErrorKey: underlyingError as Any
            ].merging(otherUserInfo, uniquingKeysWith: { $1 })
        )
    }
    
}
