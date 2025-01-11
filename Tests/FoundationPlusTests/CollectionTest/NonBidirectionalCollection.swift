import Foundation


struct NonBidirectionalCollection<Element>: Collection, RangeReplaceableCollection {

    private var elements: [Element]
    
    var startIndex: Int { 0 }
    var endIndex: Int { elements.count }
    
    init(_ elements: [Element]) {
        self.elements = elements
    }

    init() {
        self.elements = []   
    }
    
    subscript(position: Int) -> Element {
        elements[position]
    }
    
    func index(after i: Int) -> Int {
        i + 1
    }
    
    func makeIterator() -> IndexingIterator<[Element]> {
        elements.makeIterator()
    }

    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, Element == C.Element {
        elements.replaceSubrange(subrange, with: newElements)
    }
    
}


extension NonBidirectionalCollection: ExpressibleByArrayLiteral {

    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

}


extension NonBidirectionalCollection: Sendable where Element: Sendable {}