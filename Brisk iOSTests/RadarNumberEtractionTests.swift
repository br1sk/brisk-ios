import XCTest
@testable import Brisk_iOS

class RadarNumberEtractionTests: XCTestCase {

	func testValidation() {
		XCTAssertTrue("1234134513".isRadarNumber)
		XCTAssertTrue("rdar://475245".isRadarNumber)
		XCTAssertTrue("https://openradar.appspot.com/2348234823".isRadarNumber)
		XCTAssertTrue("https://openradar.appspot.com/2348234823#2345".isRadarNumber)

		XCTAssertFalse("rdar://asd234dasf2".isRadarNumber)
		XCTAssertFalse("asdf4ewe".isRadarNumber)
	}

	func testExtraction() {
		XCTAssertEqual("475245".extractRadarNumber()!, "475245")
		XCTAssertEqual("rdar://475245".extractRadarNumber(), "475245")
		XCTAssertEqual("https://openradar.appspot.com/2348234823#2345".extractRadarNumber()!, "2348234823")
	}
}
