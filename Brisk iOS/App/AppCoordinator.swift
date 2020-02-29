import AcknowList
import InterfaceBacked
import SafariServices
import Sonar
import UIKit

final class AppCoordinator {


	// MARK: - Properties

	var root = UISplitViewController()
	var masterRoot = UINavigationController()
	var loginCoordinator: LoginCoordinator?
	var radarCoordinator: RadarCoordinator?
	let api = APIController()
	let urlScheme = "brisk-rdar"


	// MARK: - Public API

	func start() -> UIWindow {

		let menu = MenuViewController.newFromStoryboard()
		menu.title = "Welcome"
		menu.delegate = self

		masterRoot.viewControllers = [menu]

		root.viewControllers = [menu]
		root.preferredDisplayMode = .allVisible

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = root
		window.makeKeyAndVisible()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.startLoginIfRequired()
		}

		return window
	}

	func handle(url: URL) -> Bool {
		guard
			let scheme = url.scheme,
			scheme == urlScheme,
			let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
			else  {
				return false
		}

#if swift(>=4.0)
		let number = String(components.path.dropFirst())
#else
		let number = String(components.path.dropFirst())
#endif
		if number.isOpenRadar {
			var autoSubmit = true
			if let queryItems = components.queryItems, let submit = queryItems.first(where: { $0.name == "submit" }) {
				autoSubmit = submit.value == "true"
			}
			showDupe(with: number, autoSearch: autoSubmit)
		}

		return true
	}


	// MARK: - Navigation

    public func handleQuick(action: QuickAction.Radar? = nil) {
        if let action = action {
            switch action {
            case .new:
                showFile()
            case .duplicate:
                showDupe()
            }
        }
    }

	fileprivate func showDupe(with number: String = "", autoSearch: Bool = false) {
		let controller = DupeViewController.newFromStoryboard()
		controller.delegate = self
		controller.number = number
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			controller.navigationItem.leftBarButtonItem = nil
		default: break
		}
		let container = UINavigationController(rootViewController: controller)
		root.showDetailViewController(container, sender: self)

		if autoSearch && number.isNotEmpty && number.isOpenRadar {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.controller(controller, didSubmit: number)
			}
		}
	}

	fileprivate func showFile(for radar: Radar? = nil, originalNumber: String = "") {
		let radarCoordinator = RadarCoordinator(from: root)
		radarCoordinator.start(with: radar, duplicateOf: originalNumber)
		self.radarCoordinator = radarCoordinator
	}

	fileprivate func startLoginIfRequired() {
		if Keychain.get(.radar) != nil {
			return
		}
		let coordinator = LoginCoordinator(from: root)
		coordinator.start()
		loginCoordinator = coordinator
	}

	fileprivate func showSettings() {
		let settings = SettingsViewController.newFromStoryboard()
		settings.delegate = self
		if UIDevice.current.userInterfaceIdiom == .pad {
			settings.navigationItem.rightBarButtonItem = nil
		}
		let container = UINavigationController(rootViewController: settings)
		container.modalPresentationStyle = .formSheet
		root.show(container, sender: self)
	}
}


// MARK: - SettingsDelegate

extension AppCoordinator: SettingsDelegate {
	func feedbackTapped() {
		let feedbackUrl = "https://github.com/br1sk/brisk-ios/issues/new"
		guard let url = URL(string: feedbackUrl) else { preconditionFailure() }
		let safari = SFSafariViewController(url: url)
		root.present(safari, animated: true)
	}

	func clearOpenradarTapped() {
		Keychain.delete(.openRadar)
		root.dismiss(animated: true) {
			self.startLoginIfRequired()
		}
	}

	func logoutTapped() {
		Keychain.delete(.radar)
        UIApplication.shared.shortcutItems = nil

		if root.presentedViewController != nil {
			root.dismiss(animated: true) {
				self.startLoginIfRequired()
			}
		} else {
			self.startLoginIfRequired()
		}
	}

	func doneTapped() {
		root.dismiss(animated: true)
	}

	func frameworksTapped() {
		let path = Bundle.main.path(forResource: "Pods-Brisk iOS-acknowledgements", ofType: "plist")
		let controller = AcknowListViewController(acknowledgementsPlistPath: path)
		guard let navigation = root.viewControllers.last as? UINavigationController else { return }
		navigation.pushViewController(controller, animated: true)
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
		root.dismiss(animated: true, completion: nil)
	}

	func controller(_ controller: DupeViewController, didSubmit number: String) {

        let loading: (Bool) -> Void = { isLoading in
            if isLoading {
                controller.showLoading()
            } else {
                controller.hideLoading()
            }
        }

        let success: (Radar) -> Void = { [weak self] (radar) in
            self?.showFile(for: radar, originalNumber: number)
        }

        let failure: (String, String) -> Void = { (errorTitle, errorMessage) in
            print("*** ERROR \(errorTitle)::\(errorMessage)")
        }

		api.search(forRadarWithId: number, loading: loading, success: success, failure: failure)
	}
}
