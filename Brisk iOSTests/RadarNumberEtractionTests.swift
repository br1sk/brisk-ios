@testable import Brisk_iOS
import XCTest

class RadarNumberEtractionTests: XCTestCase {

	func testValidation() {
		XCTAssertTrue("1234134513".isOpenRadar)
		XCTAssertTrue("rdar://475245".isOpenRadar)
		XCTAssertTrue("https://openradar.appspot.com/2348234823".isOpenRadar)
		XCTAssertTrue("https://openradar.appspot.com/2348234823#2345".isOpenRadar)

		XCTAssertFalse("rdar://asd234dasf2".isOpenRadar)
		XCTAssertFalse("asdf4ewe".isOpenRadar)
	}

	func testExtraction() {
		XCTAssertEqual("475245".extractRadarNumber()!, "475245")
		XCTAssertEqual("rdar://475245".extractRadarNumber(), "475245")
		XCTAssertEqual("https://openradar.appspot.com/2348234823#2345".extractRadarNumber()!, "2348234823")
	}
}
