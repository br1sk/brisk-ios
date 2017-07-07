import UIKit
import SVProgressHUD

protocol StatusDisplay {
	func showLoading()
	func showSuccess(message: String, autoDismissAfter delay: TimeInterval)
	func showError(title: String?, message: String, dismissButtonTitle: String?, completion: (() -> Void)?)
	func hideLoading()
}

extension StatusDisplay where Self: UIViewController {

	func showLoading() {
		SVProgressHUD.show()
	}

	func showSuccess(message: String, autoDismissAfter delay: TimeInterval = 3.0) {
		SVProgressHUD.setMinimumDismissTimeInterval(delay)
		SVProgressHUD.showSuccess(withStatus: message)
	}

	func showError(title: String? = NSLocalizedString("Global.Error", comment: ""),
	               message: String,
	               dismissButtonTitle: String? = NSLocalizedString("Global.Dismiss", comment: ""),
	               completion: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: dismissButtonTitle, style: .cancel, handler: nil))
		present(alert, animated: true, completion: completion)
	}

	func hideLoading() {
		SVProgressHUD.dismiss()
	}
}
