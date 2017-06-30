import UIKit

final class LoginCoordinator {


	// MARK: - Properties

	let source: UIViewController


	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}

	// MARK: - Public API

	func start() {
		let controller = LoginViewController()
		let nav = UINavigationController(rootViewController: controller)
		source.present(nav, animated: true, completion: nil)
	}
}
