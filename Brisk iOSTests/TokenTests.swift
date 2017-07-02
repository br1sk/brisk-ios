@testable import Brisk_iOS
import XCTest

class TokenTests: XCTestCase {

	func testPatternMatch() {
		XCTAssertTrue(Token("800f690a-5f76-11e7-a49d-cfaf62a5e748").isValid)
		XCTAssertFalse(Token("8090a-5f76-11e7-a49d-cfaf625e748").isValid)
	}
}
