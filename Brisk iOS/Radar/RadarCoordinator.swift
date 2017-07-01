import Foundation
import UIKit

final class RadarCoordinator {


	// MARK: - Properties

	let source: UIViewController
	var root = UINavigationController()
	var radarViewController: RadarViewController?


	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}


	// MARK: - Public API

	func start() {
		let controller = RadarViewController.newFromStoryboard()
		controller.delegate = self
		root.viewControllers = [controller]
		source.present(root, animated: true, completion: nil)
		radarViewController = controller
	}

}

extension RadarCoordinator: RadarViewDelegate {

	func controller(_ controller: RadarViewController, didSelectProperty property: String, with value: String, placeholder: String?) {
		let details = EnterDetailsViewController.newFromStoryboard()
		details.title = property
		details.prefilledContent = value
		details.placeholder = placeholder
		root.pushViewController(details, animated: true)

	}


	func controller(_ controller: RadarViewController, didSelectChoice choice: Choice, ofAll choices: [Choice], title: String) {
		let controller = SingleChoiceViewController.newFromStoryboard()
		controller.all = choices
		controller.title = title
		controller.selected = choice
		root.pushViewController(controller, animated: true)
	}

	func controllerDidSubmit(_ controller: RadarViewController) {
		// Show loading
		// Post radar
		let status = Status.failed

		// Hide loading

		// Show succes/error
		let controller = StatusViewController.newFromStoryboard()
		controller.status = status
		root.pushViewController(controller, animated: true)

		// Auto close after delay on success, pop on failure
		let delay = 2.0
		switch status {
		case .success:
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				self.source.dismiss(animated: true)
			}
		case .failed:
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				self.root.popViewController(animated: true)
			}
		}
	}
}
