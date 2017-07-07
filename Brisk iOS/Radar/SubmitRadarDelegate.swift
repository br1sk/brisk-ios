import Foundation
import Sonar

final class SubmitRadarDelegate: APIDelegate {


	// MARK: - Properties

	let display: StatusDisplay
	var finishHandler: (_ succes: Bool) -> Void = { _ in }


	// MARK: - Init/Deinit

	init(_ display: StatusDisplay) {
		self.display = display
	}


	// APIDelegate Methods

	func didStartLoading() {
		display.showLoading()
	}

	func didFail(with error: SonarError) {
		display.hideLoading()
		display.showError(title: nil, message: error.localizedDescription, dismissButtonTitle: nil, completion: nil)
		finishHandler(false)
	}

	func didPostToAppleRadar() {
		display.hideLoading()
		let delay = 3.0
		display.showSuccess(message: NSLocalizedString("Radar.Post.Success", comment: ""), autoDismissAfter: delay)
		finishHandler(true)
	}

	func didPostToOpenRadar() {
		display.hideLoading()
		display.showSuccess(message: NSLocalizedString("Radar.Post.Success", comment: ""), autoDismissAfter: 3.0)
		finishHandler(false)
	}

}
