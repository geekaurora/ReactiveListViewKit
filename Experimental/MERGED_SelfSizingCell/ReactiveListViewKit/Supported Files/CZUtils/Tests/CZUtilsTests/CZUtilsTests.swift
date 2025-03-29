import XCTest
@testable import CZUtils

final class CZUtilsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CZUtils().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
