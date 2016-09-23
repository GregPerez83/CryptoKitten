import XCTest
@testable import PBKDF2
import SHA1
import MD5
import HMAC

class PBKDF2Tests: XCTestCase {
    static var allTests = [
        ("testValidation", testValidation),
        ("testSHA1", testSHA1),
        ("testMD5", testMD5),
        ("testPerformance", testPerformance),
    ]
    
    func testValidation() throws {
        let result = try PBKDF2<SHA1>.derive(fromKey: "vapor".bytes, usingSalt: "V4P012".bytes, iterating: 1000, keyLength: 10)
        
        XCTAssert(try PBKDF2<SHA1>.validate(key: "vapor".bytes, usingSalt: "V4P012".bytes, against: result, iterating: 1000))
    }

    func testSHA1() throws {
        // Source: PHP/produce_tests.php
        let tests: [(key: String, salt: String, expected: String, iterations: Int)] = [
            (
                "password",
                "salt",
                "6e88be8bad7eae9d9e10aa061224034fed48d03f",
                1000
            ),
            (
                "password2",
                "othersalt",
                "7a0363dd39e51c2cf86218038ad55f6fbbff6291",
                1000
            ),
            (
                "somewhatlongpasswordstringthatIwanttotest",
                "1",
                "8cba8dd99a165833c8d7e3530641c0ecddc6e48c",
                1000
            ),
            (
                "p",
                "somewhatlongsaltstringthatIwanttotest",
                "31593b82b859877ea36dc474503d073e6d56a33d",
                1000
            ),
        ]
        
        for test in tests {
            let result = try PBKDF2<SHA1>.derive(fromKey: test.key.bytes, usingSalt: test.salt.bytes, iterating: test.iterations).hexString.lowercased()
            
            XCTAssertEqual(result, test.expected.lowercased())
        }
    }

    func testMD5() throws {
        // Source: PHP/produce_tests.php
        let tests: [(key: String, salt: String, expected: String, iterations: Int)] = [
            (
                "password",
                "salt",
                "8d189946a32d883622a16ae18af0632f",
                1000
            ),
            (
                "password2",
                "othersalt",
                "78e4d28875d6f3b92a01dbddc07370f1",
                1000
            ),
            (
                "somewhatlongpasswordstringthatIwanttotest",
                "1",
                "c91a23ffd2a352f0f49c6ce64146fc0a",
                1000
            ),
            (
                "p",
                "somewhatlongsaltstringthatIwanttotest",
                "4d0297fc7c9afd51038a0235926582bc",
                1000
            ),
        ]
        
        for test in tests {
            let result = try PBKDF2<MD5>.derive(fromKey: test.key.bytes, usingSalt: test.salt.bytes, iterating: test.iterations).hexString.lowercased()
            
            XCTAssertEqual(result, test.expected.lowercased())
        }
    }
    
    func testPerformance() {
        // ~0.137 release
        measure {
            _ = try! PBKDF2<SHA1>.derive(fromKey: "p".bytes, usingSalt: "somewhatlongsaltstringthatIwanttotest".bytes, iterating: 10_000)
        }
    }
}
