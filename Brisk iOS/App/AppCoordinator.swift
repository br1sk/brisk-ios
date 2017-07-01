import UIKit
import InterfaceBacked

final class AppCoordinator {


	// MARK: - Properties

	var root: UINavigationController?
	var loginCoordinator: LoginCoordinator?
	var radarCoordinator: RadarCoordinator?

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
		guard let root = self.root else { preconditionFailure() }
		let radarCoordinator = RadarCoordinator(from: root)
		radarCoordinator.start()
		self.radarCoordinator = radarCoordinator
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
