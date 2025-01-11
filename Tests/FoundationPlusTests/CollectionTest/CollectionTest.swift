//
//  CollectionTest.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/15.
//

import Testing
import XCTest
@testable import FoundationPlusEssential


struct CollectionTest {

    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ]
    )
    func dropLast1(
        _ collection: [Int],
        _ droppedCollection: [Int],
        _ threshold: Int
    ) async throws {
        
        let result = collection.dropLast { $0 > threshold }.toArray()
        #expect(result == droppedCollection)
        
    }


    @Test(
        arguments: [
            ("12345", "123", "3"),
            ("-0123", "-0123", "3"),
            ("45678", "", "3"),
            ("345678", "3", "3"),
            ("", "", "3"),
        ]
    )
    func dropLast2(
        _ collection: String,
        _ droppedCollection: String,
        _ target: Character
    ) async throws {

        let result = String(collection.dropLast { $0 != target })
        #expect(result == droppedCollection)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    )
    func dropLast3(
        _ collection: NonBidirectionalCollection<Int>,
        _ droppedCollection: [Int],
        _ threshold: Int
    ) async throws {
        
        let result = collection.dropLast { $0 > threshold }.toArray()
        #expect(result == droppedCollection)
        
    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [4,5], 3),
            ([-1,0,1,2,3], [], 3),
            ([4,5,6,7,8], [4,5,6,7,8], 3),
            ([3,4,5,6,7,8], [4,5,6,7,8], 3),
            ([], [], 3),
        ]
    ) 
    func suffix1(
        _ collection: [Int],
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        let suffix = collection.suffix(while: { $0 > threshold }).toArray()
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ("12345", "45", "3"),
            ("-0123", "", "3"),
            ("45678", "45678", "3"),
            ("345678", "45678", "3"),
            ("", "", "3"),
        ]
    )
    func suffix2(
        _ collection: String,
        _ result: String,
        _ target: Character
    ) async throws {

        let suffix = String(collection.suffix(while: { $0 != target }))
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [4,5], 3),
            ([-1,0,1,2,3], [], 3),
            ([4,5,6,7,8], [4,5,6,7,8], 3),
            ([3,4,5,6,7,8], [4,5,6,7,8], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    ) 
    func suffix3(
        _ collection: NonBidirectionalCollection<Int>,
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        let suffix = collection.suffix(while: { $0 > threshold }).toArray()
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ]
    )
    func trimmingSuffix1(
        _ collection: [Int],
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        let suffix = collection.trimmingSuffix(while: { $0 > threshold }).toArray()
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ("12345", "123", "3"),
            ("-0123", "-0123", "3"),
            ("45678", "", "3"),
            ("345678", "3", "3"),
            ("", "", "3"),
        ]
    )
    func trimmingSuffix2(
        _ collection: String,
        _ result: String,
        _ target: Character
    ) async throws {

        let suffix = String(collection.trimmingSuffix(while: { $0 != target }))
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    )
    func trimmingSuffix1(
        _ collection: NonBidirectionalCollection<Int>,
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        let suffix = collection.trimmingSuffix(while: { $0 > threshold }).toArray()
        #expect(suffix == result)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ]
    )
    func trimSuffix1(
        _ collection: [Int],
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        var collection = collection
        collection.trimSuffix(while: { $0 > threshold })
        #expect(collection == result)

    }


    @Test(
        arguments: [
            ("12345", "123", "3"),
            ("-0123", "-0123", "3"),
            ("45678", "", "3"),
            ("345678", "3", "3"),
            ("", "", "3"),
        ]
    )
    func trimSuffix2(
        _ collection: String,
        _ result: String,
        _ target: Character
    ) async throws {

        var collection = collection
        collection.trimSuffix(while: { $0 != target })
        #expect(collection == result)

    }


    @Test(
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    )
    func trimSuffix3(
        _ collection: NonBidirectionalCollection<Int>,
        _ result: [Int],
        _ threshold: Int
    ) async throws {

        var collection = collection
        collection.trimSuffix(while: { $0 > threshold })
        #expect(collection.toArray() == result)

    }

}



// class CollectionPerformanceTest: XCTestCase {

//     func testDropLastPerformance1() {
        
//         let collection = Array(0..<10000000)
//         measure {
//             let _ = collection.dropLast { $0 < Int.max }
//         }

//     }


//     func testSuffixPerformance1() {
        
//         let collection = Array(0..<10000000)
//         measure {
//             let _ = collection.suffix(while: { $0 < Int.max })
//         }

//     }

// }