//
//  Utils.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import ConcurrencyPlus



extension FileManager {
    
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)

    /// Run the provided operation closure on the dedicated IO queue
    @available(macOS, deprecated: 15.0)
    @available(iOS, deprecated: 18.0)
    @available(watchOS, deprecated: 11.0)
    @available(tvOS, deprecated: 18.0)
    @available(visionOS, deprecated: 2.0)
    public static func runOnIOQueue<R, E: Error>(
        _ operation: @escaping () throws(E) -> R
    ) async throws(E) -> R {
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) { () throws(E) -> R in 
                try operation() 
            }
        } else {
            try await Task.launch(on: .io, operation: operation)
        }
    }

#endif
    
    
    /// Assert that the current code is running on the dedicated IO queue
    public static func assertOnIOQueue() {
        dispatchPrecondition(condition: .onQueue(FoundationPlusTaskExecutor.io.queue))
    }
    
}



@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension FileManager {

    /// Run the provided operation closure on the dedicated IO queue
    public static func runOnIOQueue<R>(operation: () throws -> R) async rethrows -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {  
            try operation() 
        }
    }

}