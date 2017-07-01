import Foundation
import UIKit
import Sonar

class EditableRadar: NSObject {
	var classification: Classification = .Security
	var product: Product = .iOS
	var reproducibility: Reproducibility = .Always
	var title = ""
	var radarDescription = ""
	var steps = ""
	var expected = ""
	var actual = ""
	var configuration = ""
	var version = ""
	var notes = ""
	var area: Area?
	var attachments = [Attachment]()
}

final class RadarCoordinator {


	// MARK: - Properties

	let source: UIViewController
	var root = UINavigationController()
	var radarViewController: RadarViewController?
	var radar = EditableRadar()
	var editingKeypath = ""

	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}


	// MARK: - Public API

	func start() {
		let controller = RadarViewController.newFromStoryboard()
		controller.delegate = self
		controller.radar = radar
		root.viewControllers = [controller]
		source.present(root, animated: true, completion: nil)
		radarViewController = controller
	}


	// MARK: - Private Methods

	fileprivate func showSingleChoice(forKeypath keypath: String, selected: Choice, all: [Choice], title: String) {
		editingKeypath = keypath
		let controller = SingleChoiceViewController.newFromStoryboard()
		controller.all = all
		controller.title = title
		controller.selected = selected
		controller.delegate = self
		root.pushViewController(controller, animated: true)
	}

	fileprivate func showEnterDetails(forKeypath keypath: String, content: String, placeholder: String = "", title: String) {
		editingKeypath = keypath
		let details = EnterDetailsViewController.newFromStoryboard()
		details.title = title
		details.prefilledContent = content
		details.placeholder = placeholder
		root.pushViewController(details, animated: true)
	}
}


// MARK: - EnterDetailsDelegate Methods


extension RadarCoordinator: EnterDetailsDelegate {

	func controller(_ controller: EnterDetailsViewController, didEnter content: String) {
		radar.setValue(content, forKey: editingKeypath)
		radarViewController?.radar = radar
	}
}

// MARK: - SingleChoiceDelegate Methods

extension RadarCoordinator: SingleChoiceDelegate {

	func controller(_ controller: SingleChoiceViewController, didSelect choice: Choice) {
	}
}

// MARK: - RadarViewDelegate Methods

extension RadarCoordinator: RadarViewDelegate {

	func controllerDidSelectProduct(_ controller: RadarViewController) {
		showSingleChoice(forKeypath: "product", selected: radar.product, all: Product.All, title: NSLocalizedString("Radar.Product", comment: ""))
	}

	func controllerDidSelectArea(_ controller: RadarViewController) {
		showSingleChoice(forKeypath: "area", selected: radar.area!, all: Area.areas(for: radar.product), title: NSLocalizedString("Radar.Area", comment: ""))
	}

	func controllerDidSelectVersion(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "version", content: radar.version, title: NSLocalizedString("Radar.Version", comment: ""))
	}

	func controllerDidSelectClassification(_ controller: RadarViewController) {
		showSingleChoice(forKeypath: "classification", selected: radar.classification, all: Classification.All, title: NSLocalizedString("Radar.Classification", comment: ""))
	}

	func controllerDidSelectReproducibility(_ controller: RadarViewController) {
		showSingleChoice(forKeypath: "reproducibility", selected: radar.reproducibility, all: Reproducibility.All, title: NSLocalizedString("Radar.Reproducibility", comment: ""))
	}

	func controllerDidSelectConfiguration(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "configuration", content: radar.configuration, title: NSLocalizedString("Radar.Configuration", comment: ""))
	}

	func controllerDidSelectTitle(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "title", content: radar.title, title: NSLocalizedString("Radar.Title", comment: ""))
	}

	func controllerDidSelectDescription(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "radarDescription",
		                 content: radar.description,
		                 placeholder: NSLocalizedString("Radar.Description.Placeholder", comment: ""),
		                 title: NSLocalizedString("Radar.Description", comment: ""))
	}

	func controllerDidSelectSteps(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "steps",
		                 content: radar.steps,
		                 placeholder: NSLocalizedString("Radar.Steps.Placeholder", comment: ""),
		                 title: NSLocalizedString("Radar.Steps", comment: ""))
	}

	func controllerDidSelectExpected(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "expected",
		                 content: radar.expected,
		                 placeholder: NSLocalizedString("Radar.Expected.Placeholder", comment: ""),
		                 title: NSLocalizedString("Radar.Expected", comment: ""))
	}

	func controllerDidSelectActual(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "actual",
		                 content: radar.actual,
		                 placeholder: NSLocalizedString("Radar.Actual.Placeholder", comment: ""),
		                 title: NSLocalizedString("Radar.Actual", comment: ""))
	}

	func controllerDidSelectNotes(_ controller: RadarViewController) {
		showEnterDetails(forKeypath: "notes",
		                 content: radar.notes,
		                 placeholder: NSLocalizedString("Radar.Notes.Placeholder", comment: ""),
		                 title: NSLocalizedString("Radar.Notes", comment: ""))
	}

	func controllerDidSelectAttachments(_ controller: RadarViewController) {

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
