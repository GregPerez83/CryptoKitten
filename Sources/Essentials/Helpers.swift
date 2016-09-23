import Foundation
import Core

public protocol SequenceInitializable: Sequence {
    init(_ sequence: [Iterator.Element])
}

/**
    Provides access to hexStrings

    Move to vapor/core
*/
extension SequenceInitializable where Iterator.Element == Byte {
    
    public init(hexString: String) {
        var data = Bytes()
        
        var gen = hexString.characters.makeIterator()
        while let c1 = gen.next(), let c2 = gen.next() {
            let s = String([c1, c2])
            
            guard let d = Byte(s, radix: 16) else {
                break
            }
            
            data.append(d)
        }
        
        self.init(data)
    }
}

extension Sequence where Iterator.Element == Byte {
    public var hexString: String {
        #if os(Linux)
            return self.lazy.reduce("") { $0 + (NSString(format:"%02x", $1).description) }
        #else
            let s = self.lazy.reduce("") { $0 + String(format:"%02x", $1) }

            return s
        #endif
    }
}

public func bitLength(of length: Int, reversed: Bool = true) -> Bytes {
    let lengthBytes = arrayOfBytes(length * 8, length: 8)
    
    return reversed ? lengthBytes.reversed() : lengthBytes
}
