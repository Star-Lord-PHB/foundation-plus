//
//  URL.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation

extension URL {
    
    public func compactPath(percentEncoded: Bool = true) -> String {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            self.path(percentEncoded: percentEncoded)
        } else {
            self.path
        }
    }
    
}
