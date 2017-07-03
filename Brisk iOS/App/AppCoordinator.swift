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
		nav.setNavigationBarHidden(true, animated: false)
		self.root = nav

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = nav
		window.makeKeyAndVisible()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.startLoginIfRequired()
		}

		return window
	}


	// MARK: - Navigation

	fileprivate func showDupe() {
		let controller = DupeViewController.newFromStoryboard()
		controller.delegate = self
		let container = UINavigationController(rootViewController: controller)
		root?.showDetailViewController(container, sender: self)
	}

	fileprivate func showFile() {
		guard let root = self.root else { preconditionFailure() }
		let radarCoordinator = RadarCoordinator(from: root)
		radarCoordinator.start()
		self.radarCoordinator = radarCoordinator
	}

	fileprivate func startLoginIfRequired() {
		guard let root = self.root else { preconditionFailure() }
		if let (_, _) = Keychain.get(.radar) {
			return
		}
		let coordinator = LoginCoordinator(from: root)
		coordinator.start()
		loginCoordinator = coordinator
	}

	fileprivate func showSettings() {
		let settings = SettingsViewController.newFromStoryboard()
		settings.delegate = self
		let container = UINavigationController(rootViewController: settings)
		root?.showDetailViewController(container, sender: self)
	}
}


// MARK: - SettingsDelegate

extension AppCoordinator: SettingsDelegate {

	func doneTapped() {
		root?.dismiss(animated: true)
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

	func settingsTapped() {
		showSettings()
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
