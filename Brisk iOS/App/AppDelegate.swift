import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


	// MARK: - Properties

	var window: UIWindow?
	var appCoordinator: AppCoordinator?

	// MARK: - UIApplicationDelegate Methods

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		let coordinator = AppCoordinator()
		window = coordinator.start()
		appCoordinator = coordinator
		return true
	}

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let type = QuickAction.Radar(rawValue: shortcutItem.type) {
            appCoordinator?.handleQuick(action: type)
            completionHandler(true)
        }
    }

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		guard let coordinator = appCoordinator else { return false }
		return coordinator.handle(url: url)
	}
}
