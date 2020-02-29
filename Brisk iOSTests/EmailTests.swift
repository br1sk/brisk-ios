@testable import Brisk_iOS
import XCTest

class EmailTests: XCTestCase {

	func testPatternMatch() {
		XCTAssertTrue(Email("foo@bar.design").isValid)
		XCTAssertFalse(Email("e@.com").isValid)
		XCTAssertFalse(Email("e@asdcom").isValid)
		XCTAssertFalse(Email("e@com.").isValid)
	}
}
