import UIKit
import InterfaceBacked

final class AppCoordinator {


	// MARK: - Properties

	var root: UINavigationController?
	var loginCoordinator: LoginCoordinator?

	// MARK: - Public API

	func start() -> UIWindow {

		let menu = MenuViewController.newFromStoryboard()
		menu.delegate = self

		let nav = UINavigationController(rootViewController: menu)
		self.root = nav

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = nav
		window.makeKeyAndVisible()

//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//			self.startLoginIfRequired()
//		}

		return window
	}


	// MARK: - Navigation

	fileprivate func showDupe() {
		let controller = DupeViewController.newFromStoryboard()
		controller.delegate = self
		let container = UINavigationController(rootViewController: controller)
		root?.present(container, animated: true, completion: nil)
	}

	fileprivate func showFile() {
		let controller = RadarViewController.newFromStoryboard()
		controller.delegate = self
		let container = UINavigationController(rootViewController: controller)
		root?.present(container, animated: true)
	}

	fileprivate func showEnterDetails(title: String, placeholder: String?) {
		let details = EnterDetailsViewController.newFromStoryboard()
		details.title = title
		details.placeholder = placeholder
		guard let nav = root?.presentedViewController as? UINavigationController else { preconditionFailure() }
		nav.pushViewController(details, animated: true)
	}

	fileprivate func startLoginIfRequired() {
		// TODO: If log in required
		guard let root = self.root else { preconditionFailure() }
		let coordinator = LoginCoordinator(from: root)
		coordinator.start()
		loginCoordinator = coordinator
	}

}


// MARK: - MenuViewDelegate Methods

extension AppCoordinator: MenuViewDelegate {

	func dupeTapped() {
		showDupe()
	}

	func fileTapped() {
		showFile()
	}
}

// MARK: - DupeViewDelegate Methods

extension AppCoordinator: DupeViewDelegate {

	func controllerDidCancel(_ controller: DupeViewController) {
		root?.dismiss(animated: true, completion: nil)
	}

	func controller(_ controller: DupeViewController, didSubmit number: String) {
		print("Did submit number \(number)")
	}
}

// MARK: - RadarViewDelegate Methods

extension AppCoordinator: RadarViewDelegate {

	func controller(_ controller: RadarViewController, didSelectTitle title: String, placeholder: String?) {
		showEnterDetails(title: title, placeholder: placeholder)
	}

	func controllerDidSubmit(_ controller: RadarViewController) {
		// Show loading
		// Post radar
		let status = Status.failed

		// Hide loading

		// Show succes/error
		let controller = StatusViewController.newFromStoryboard()
		controller.status = status
		guard let navigation = root?.presentedViewController as? UINavigationController else { preconditionFailure() }
		navigation.pushViewController(controller, animated: true)

		// Auto close after delay on success, pop on failure
		let delay = 2.0
		switch status {
		case .success:
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				self.root?.dismiss(animated: true)
			}
		case .failed:
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				navigation.popViewController(animated: true)
			}
		}
	}
}
