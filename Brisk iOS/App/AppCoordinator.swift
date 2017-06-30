import UIKit

final class AppCoordinator {


	// MARK: - Properties

	var root: UIViewController?
	var loginCoordinator: LoginCoordinator?

	// MARK: - Public API

	func start() -> UIWindow {

		let menu = MenuViewController()
		menu.delegate = self

		let nav = UINavigationController(rootViewController: menu)
		self.root = nav

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = nav
		window.makeKeyAndVisible()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.startLoginIfRequired()
		}

		return window
	}


	// MARK: - Private

	private func startLoginIfRequired() {
		guard let root = self.root else { preconditionFailure() }
		let coordinator = LoginCoordinator(from: root)
		coordinator.start()
		loginCoordinator = coordinator
	}
}


// MARK: - MenuViewDelegate Methods

extension AppCoordinator: MenuViewDelegate {

	func dupeTapped() {
		print(#function)
	}

	func fileTapped() {
		print(#function)
	}
}
