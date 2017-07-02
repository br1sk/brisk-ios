import Foundation
import UIKit
import Sonar


final class RadarCoordinator {


	// MARK: - Types

	struct ViewModel {
		var product: Product = .iOS
		var area: Area? = Area.areas(for: .iOS).first
		var classification: Classification = .Security
		var reproducibility: Reproducibility = .Always
		var title: String = ""
		var description: String = ""
		var steps: String = ""
		var expected: String = ""
		var actual: String = ""
		var configuration: String = ""
		var version: String = ""
		var notes: String = ""
		var attachments: [Attachment] = []
	}

	// MARK: - Properties

	let source: UIViewController
	var root = UINavigationController()
	var radarViewController: RadarViewController?
	var editingKeypath = ""
	var radar = ViewModel() {
		didSet {
			self.radarViewController?.radar = radar
		}
	}

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

	fileprivate func showSingleChoice<T: Choice>(selected: T, all: [T], onSelect: @escaping (T) -> Void) {
		let singleChoice: SingleChoiceViewController<T> = SingleChoiceViewController()
		singleChoice.all = all
		singleChoice.selected = selected
		singleChoice.onSelect = { [unowned self] choice in
			onSelect(choice)
			self.root.popViewController(animated: true)
		}
		root.show(singleChoice, sender: self)
	}

	fileprivate func showEnterDetails(title: String, content: String, placeholder: String, onDisappear: @escaping (String) -> Void) {
		let enterDetails = EnterDetailsViewController.newFromStoryboard()
		enterDetails.prefilledContent = content
		enterDetails.placeholder = placeholder
		enterDetails.title = title
		enterDetails.onDisappear = onDisappear
		root.show(enterDetails, sender: self)
	}
}


// MARK: - RadarViewDelegate Methods

extension RadarCoordinator: RadarViewDelegate {

	func controllerDidSelectProduct(_ controller: RadarViewController) {
		showSingleChoice(selected: radar.product, all: Product.All) { [unowned self] choice in
			self.radar.product = choice
			self.radar.area = Area.areas(for: choice).first
		}
	}

	func controllerDidSelectArea(_ controller: RadarViewController) {
		let areas = Area.areas(for: radar.product)
		guard areas.isNotEmpty, let area = radar.area else { return }
		showSingleChoice(selected: area, all: areas) { [unowned self] choice in
			self.radar.area = choice
		}
	}

	func controllerDidSelectVersion(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Version", comment: ""), content: radar.version, placeholder: "") { [unowned self] (text) in
			self.radar.version = text
		}
	}

	func controllerDidSelectClassification(_ controller: RadarViewController) {
		showSingleChoice(selected: radar.classification, all: Classification.All) { [unowned self] choice in
			self.radar.classification = choice
		}
	}

	func controllerDidSelectReproducibility(_ controller: RadarViewController) {
		showSingleChoice(selected: radar.reproducibility, all: Reproducibility.All) { [unowned self] choice in
			self.radar.reproducibility = choice
		}
	}

	func controllerDidSelectConfiguration(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Configuration", comment: ""), content: radar.configuration, placeholder: "") { [unowned self] (text) in
			self.radar.configuration = text
		}
	}

	func controllerDidSelectTitle(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Title", comment: ""), content: radar.title, placeholder: "") { [unowned self] (text) in
			self.radar.title = text
		}
	}

	func controllerDidSelectDescription(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Description", comment: ""),
		                 content: radar.description,
		                 placeholder: NSLocalizedString("Radar.Description.Placeholder", comment: "")) { [unowned self] (text) in
			self.radar.description = text
		}
	}

	func controllerDidSelectSteps(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Steps", comment: ""),
		                 content: radar.steps,
		                 placeholder: NSLocalizedString("Radar.Steps.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.steps = text
		}
	}

	func controllerDidSelectExpected(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Expected", comment: ""),
		                 content: radar.expected,
		                 placeholder: NSLocalizedString("Radar.Expected.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.expected = text
		}
	}

	func controllerDidSelectActual(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Actual", comment: ""),
		                 content: radar.actual,
		                 placeholder: NSLocalizedString("Radar.Actual.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.actual = text
		}
	}

	func controllerDidSelectNotes(_ controller: RadarViewController) {
		showEnterDetails(title: NSLocalizedString("Radar.Notes", comment: ""),
		                 content: radar.notes,
		                 placeholder: NSLocalizedString("Radar.Notes.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.notes = text
		}
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

extension RadarCoordinator.ViewModel {

	init(radar: Radar) {
		product = radar.product
		area = radar.area ?? Area.areas(for: product).first!
		classification = radar.classification
		reproducibility = radar.reproducibility
		title = radar.title
		description = radar.description
		steps = radar.steps
		expected = radar.expected
		actual = radar.actual
		configuration = radar.configuration
		version = radar.version
		notes = radar.notes
		attachments = radar.attachments
	}

	func createRadar() -> Radar {
		return Radar(
			classification: classification,
			product: product,
			reproducibility: reproducibility,
			title: title,
			description: description,
			steps: steps,
			expected: expected,
			actual: actual,
			configuration: configuration,
			version: version,
			notes: notes,
			attachments: attachments
		)
	}
}
