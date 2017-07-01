import UIKit

final class LoginCoordinator {


	// MARK: - Properties

	let source: UIViewController
	var loginController: LoginViewController?

	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}

	// MARK: - Public API

	func start() {
		let controller = LoginViewController.newFromStoryboard()
		controller.delegate = self
		let nav = UINavigationController(rootViewController: controller)
		source.present(nav, animated: true, completion: nil)
		loginController = controller
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

	func controller(_ controller: LoginViewController, didSubmit user: User) {
		guard user.email.isValid else {
			showError(.invalidEmail)
			return
		}
	}

}
