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

}
