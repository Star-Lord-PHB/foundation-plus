import Foundation
import SystemPackage


extension FileHandle {

    public convenience init(forReadingFrom path: FilePath) throws {
        try self.init(forReadingFrom: path.toURL())
    }


    public convenience init(forWritingTo path: FilePath) throws {
        try self.init(forWritingTo: path.toURL())
    }


    public convenience init(forUpdating path: FilePath) throws {
        try self.init(forUpdating: path.toURL())
    }

}