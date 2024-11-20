//
//  SysCommandTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/9/17.
//

import Testing
@testable import FoundationPlus


struct SysCommandTest {
    
    @Test("Test launching process")
    func sysCommand1() async throws {
        
        guard let output = try await sysCommand("/usr/bin/env", "swift", "-h") else {
            try #require(Bool(false), "no command output")
            return 
        }
        
        print(String(data: output, encoding: .utf8) ?? "")
        
    }
    
}
