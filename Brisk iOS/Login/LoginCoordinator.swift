import UIKit
import SafariServices

private let kAPIKeyURL = URL(string: "https://openradar.appspot.com/apikey")!
private let kOpenRadarUsername = "openradar"

final class LoginCoordinator {


	// MARK: - Properties

	let source: UIViewController
	var loginController: LoginViewController?
	let root = UINavigationController()

	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}

	// MARK: - Public API

	func start() {
		let controller = LoginViewController.newFromStoryboard()
		controller.delegate = self
		root.viewControllers = [controller]
		source.present(root, animated: true, completion: nil)
		loginController = controller
	}

	func finish() {
		source.dismiss(animated: true)
	}

	// MARK: - Private

	fileprivate func showError(_ error: LoginError) {
		let alert = UIAlertController(title: NSLocalizedString("Global.Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
		let cancel = UIAlertAction(title: NSLocalizedString("Global.Error.TryAgain", comment: ""), style: .cancel) { [weak self] _ in
			self?.loginController?.dismiss(animated: true, completion: nil)
		}
		alert.addAction(cancel)
		loginController?.present(alert, animated: true, completion: nil)
	}
}


// MARK: - LoginViewDelegate Methods

extension LoginCoordinator: LoginViewDelegate {

	func submitTapped(user: User) {
		guard user.email.isValid else {
			showError(.invalidEmail)
			return
		}
		// Show loading
		// Login
		// Hide loading
		// Continue to open radar
		let openradar = OpenRadarViewController.newFromStoryboard()
		openradar.delegate = self
		root.show(openradar, sender: self)
	}

}


// MARK: - OpenRadarViewDelegate Method

extension LoginCoordinator: OpenRadarViewDelegate {

	func openSafariTapped() {
		let safari = SFSafariViewController(url: kAPIKeyURL)
		root.showDetailViewController(safari, sender: self)
	}

	func continueTapped() {
		// Save to keychain
		finish()
	}

	func skipTapped() {
		finish()
	}

}
