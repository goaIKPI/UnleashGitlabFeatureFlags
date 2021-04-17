import XCTest
@testable import UnleashFeatureFlags

final class UnleashFeatureFlagsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UnleashFeatureFlags().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
