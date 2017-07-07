import XCTest
@testable import Brisk_iOS
@testable import Sonar

final class MockDisplay: StatusDisplay {
	var didShowLoading = false
	var didShowError = false
	var didHideLoading = false
	var didShowSuccess = false
	func showLoading() {
		didShowLoading = true
	}
	func showSuccess(message: String, autoDismissAfter delay: TimeInterval) {
		didShowSuccess = true
	}
	func showError(title: String?, message: String, dismissButtonTitle: String?, completion: (() -> Void)?) {
		didShowError = true
	}
	func hideLoading() {
		didHideLoading = true
	}
}

final class SubmitRadarTests: XCTestCase {

	func testShowLoading() {
		let display = MockDisplay()
		let sut = SubmitRadarDelegate(display)
		sut.didStartLoading()
		XCTAssertTrue(display.didShowLoading)
	}

	func testShowError() {
		let e = expectation(description: "Wait for finish to be called")
		let display = MockDisplay()
		let sut = SubmitRadarDelegate(display)
		sut.finishHandler = { _ in
			e.fulfill()
		}
		sut.didFail(with: SonarError.unknownError)
		XCTAssertTrue(display.didHideLoading)
		XCTAssertTrue(display.didShowError)
		wait(for: [e], timeout: 1.0)
	}

	func testShowSuccessWhenOpenradarFinished() {
		let e = expectation(description: "Wait for finish to be called")
		let display = MockDisplay()
		let sut = SubmitRadarDelegate(display)
		sut.finishHandler = { _ in
			e.fulfill()
		}
		sut.didPostToOpenRadar()
		XCTAssertTrue(display.didHideLoading)
		XCTAssertTrue(display.didShowSuccess)
		wait(for: [e], timeout: 1.0)
	}
}
