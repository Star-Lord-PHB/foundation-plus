import Testing
@testable import FoundationPlusEssential


extension CollectionTest {

    @Test(
        "Test NonBidirectionalCollection dropLast(while:)",
        arguments: [
            ([1,2,3,4,5], [1,2,3], 3),
            ([-1,0,1,2,3], [-1,0,1,2,3], 3),
            ([4,5,6,7,8], [], 3),
            ([3,4,5,6,7,8], [3], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    )
    func nonBidirectionalDropLast1(
        _ collection: NonBidirectionalCollection<Int>,
        _ droppedCollection: [Int],
        _ threshold: Int
    ) async throws {
        
        let result = collection.dropLast { $0 > threshold }.toArray()
        #expect(result == droppedCollection)

    }


    @Test(
        "Test NonBidirectionalCollection suffix(while:)",
        arguments: [
            ([1,2,3,4,5], [4,5], 3),
            ([-1,0,1,2,3], [], 3),
            ([4,5,6,7,8], [4,5,6,7,8], 3),
            ([3,4,5,6,7,8], [4,5,6,7,8], 3),
            ([], [], 3),
        ] as [(NonBidirectionalCollection<Int>, [Int], Int)]
    )
    func nonBidirectionalSuffix1(
        _ collection: NonBidirectionalCollection<Int>,
        _ suffix: [Int],
        _ threshold: Int
    ) async throws {
        
        let result = collection.suffix { $0 > threshold }.toArray()
        #expect(result == suffix)

    }

}