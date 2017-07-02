import XCTest
@testable import Brisk_iOS

class EmailTests: XCTestCase {

	func testPatternMatch() {
		XCTAssertTrue(Email("foo@bar.design").isValid)
		XCTAssertFalse(Email("e@.com").isValid)
		XCTAssertFalse(Email("e@asdcom").isValid)
		XCTAssertFalse(Email("e@com.").isValid)
	}
}
