//
//  CollectionTest.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/15.
//

import Testing

struct CollectionTest {

    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3]),
            ([4,5,6,7,8], []),
            ([-1,0,1,2,3], [-1,0,1,2,3])
        ]
    )
    func testDropLast(
        _ collection: [Int],
        _ droppedCollection: [Int]
    ) async throws {
        
        let result = collection.dropLast { $0 > 3 }.toArray()
        #expect(result == droppedCollection)
        
    }

}
