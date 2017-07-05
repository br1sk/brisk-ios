import UIKit
import SVProgressHUD

protocol Loading {
	func showLoading()
	func showSuccess(message: String, autoDismissAfter delay: TimeInterval)
	func hideLoading()
}

extension Loading where Self: UIViewController {

	func showLoading() {
		SVProgressHUD.show()
	}

	func showSuccess(message: String, autoDismissAfter delay: TimeInterval = 3.0) {
		SVProgressHUD.setMinimumDismissTimeInterval(delay)
		if SVProgressHUD.isVisible() == false {
			SVProgressHUD.showSuccess(withStatus: message)
		}
	}

	func hideLoading() {
		SVProgressHUD.dismiss()
	}
}
