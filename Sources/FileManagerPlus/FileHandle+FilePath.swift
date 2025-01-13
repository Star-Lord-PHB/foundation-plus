import Foundation
import SystemPackage


extension FileHandle {

    /// Open a file handle for reading the file at the specified file path.
    public convenience init(forReadingFrom path: FilePath) throws {
        try self.init(forReadingFrom: path.toURL())
    }


    /// Open a file handle for writing to the file at the specified file path.
    public convenience init(forWritingTo path: FilePath) throws {
        try self.init(forWritingTo: path.toURL())
    }


    /// Open a file handle for updating the file at the specified file path.
    public convenience init(forUpdating path: FilePath) throws {
        try self.init(forUpdating: path.toURL())
    }

}