import Foundation
import UIKit
import Sonar

// FIXME: This grew fast. Extract stuff...

final class RadarCoordinator: NSObject {


	// MARK: - Properties

	let source: UIViewController
	var root = UINavigationController()
	var radarViewController: RadarViewController?
	var editingKeypath = ""
	var radar = RadarViewModel() {
		didSet {
			self.radarViewController?.radar = radar
		}
	}
	lazy var publisher: SubmitRadarDelegate = {
		guard let radarViewController = self.radarViewController else { preconditionFailure() }
		return SubmitRadarDelegate(radarViewController)
	}()
	lazy var twoFactor: TwoFactorAuthentication = {
		guard let radarViewController = self.radarViewController else { preconditionFailure() }
		return TwoFactorAuthentication(viewController: radarViewController)
	}()
	lazy var api: APIController = {
		return APIController(delegate: self.publisher, twoFactorHandler: self.twoFactor)
	}()


	// MARK: - Init/Deinit

	init(from source: UIViewController) {
		self.source = source
	}


	// MARK: - Public API

	func start(with radar: Radar? = nil, duplicateOf: String) {
		let controller = RadarViewController.newFromStoryboard()
		controller.delegate = self
		if let radar = radar {
			self.radar = RadarViewModel(radar)
			controller.duplicateOf = duplicateOf
			controller.title = Localizable.Radar.View.Title.duplicate.localized
		} else {
			controller.title = Localizable.Radar.View.Title.new.localized
		}
		controller.radar = self.radar
		root.viewControllers = [controller]
		source.showDetailViewController(root, sender: self)
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			controller.navigationItem.leftBarButtonItem = nil
		default: break
		}
		radarViewController = controller
	}

	func finish() {
		radar = RadarViewModel()
		source.dismiss(animated: true)
	}


	// MARK: - Private Methods

	fileprivate func showSingleChoice<T: Choice>(selected: T, all: [T], onSelect: @escaping (T) -> Void) {
		let singleChoice: SingleChoiceViewController<T> = SingleChoiceViewController()
		singleChoice.all = all
		singleChoice.selected = selected
		singleChoice.onSelect = { [unowned self] choice in
			onSelect(choice)
			switch UIDevice.current.userInterfaceIdiom {
			case .pad:
				singleChoice.dismiss(animated: true)
				if let selected = self.radarViewController?.tableView.indexPathForSelectedRow {
					self.radarViewController?.tableView.deselectRow(at: selected, animated: true)
				}
			case .phone:
				self.root.popViewController(animated: true)
			default:
				break
			}
		}

		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			singleChoice.modalPresentationStyle = .popover
			root.present(singleChoice, animated: true)
			if let popover = singleChoice.popoverPresentationController {
				popover.sourceView = radarViewController?.view
				popover.delegate = self
				if let selected = radarViewController?.tableView.indexPathForSelectedRow, let frame = radarViewController?.tableView.rectForRow(at: selected) {
					popover.sourceRect = frame
				}
			}
		case .phone:
			root.show(singleChoice, sender: self)
		default:
			break
		}
	}

	fileprivate func showEnterDetails(title: String, content: String, placeholder: String, onDisappear: @escaping (String) -> Void) {
		let enterDetails = EnterDetailsViewController.newFromStoryboard()
		enterDetails.prefilledContent = content
		enterDetails.placeholder = placeholder
		enterDetails.title = title
		enterDetails.onDisappear = onDisappear

		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			let container = UINavigationController(rootViewController: enterDetails)
			container.modalPresentationStyle = .formSheet
			root.present(container, animated: true)
			enterDetails.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RadarCoordinator.enterDetailsDidFinish))
		case .phone:
			root.show(enterDetails, sender: self)
		default:
			break
		}

	}

	@objc fileprivate func enterDetailsDidFinish() {
		root.presentedViewController?.dismiss(animated: true)
		if let selected = radarViewController?.tableView.indexPathForSelectedRow {
			radarViewController?.tableView.deselectRow(at: selected, animated: true)
		}
	}
}


// MARK: - RadarViewDelegate Methods

extension RadarCoordinator: RadarViewDelegate {

	func productTapped() {
		showSingleChoice(selected: radar.product, all: Product.All) { [unowned self] choice in
			self.radar.product = choice
			self.radar.area = Area.areas(for: choice).first
		}
	}

	func areaTapped() {
		let areas = Area.areas(for: radar.product)
		guard areas.isNotEmpty, let area = radar.area else { return }
		showSingleChoice(selected: area, all: areas) { [unowned self] choice in
			self.radar.area = choice
		}
	}

	func versionTapped() {
		showEnterDetails(title: Localizable.Radar.version.localized, content: radar.version, placeholder: "") { [unowned self] (text) in
			self.radar.version = text
		}
	}

	func classificationTapped() {
		showSingleChoice(selected: radar.classification, all: Classification.All) { [unowned self] choice in
			self.radar.classification = choice
		}
	}

	func reproducibilityTapped() {
		showSingleChoice(selected: radar.reproducibility, all: Reproducibility.All) { [unowned self] choice in
			self.radar.reproducibility = choice
		}
	}

	func configurationTapped() {
		showEnterDetails(title: Localizable.Radar.configuration.localized, content: radar.configuration, placeholder: "") { [unowned self] (text) in
			self.radar.configuration = text
		}
	}

	func titleTapped() {
		showEnterDetails(title: Localizable.Radar.title.localized, content: radar.title, placeholder: "") { [unowned self] (text) in
			self.radar.title = text
		}
	}

	func descriptionTapped() {
		showEnterDetails(title: Localizable.Radar.description.localized,
		                 content: radar.description,
		                 placeholder: Localizable.Radar.Placeholder.description.localized) { [unowned self] (text) in
			self.radar.description = text
		}
	}

	func stepsTapped() {
		showEnterDetails(title: Localizable.Radar.steps.localized,
		                 content: radar.steps,
		                 placeholder: Localizable.Radar.Placeholder.steps.localized) { [unowned self] (text) in
							self.radar.steps = text
		}
	}

	func expectedTapped() {
		showEnterDetails(title: Localizable.Radar.expected.localized,
		                 content: radar.expected,
		                 placeholder: Localizable.Radar.Placeholder.expected.localized) { [unowned self] (text) in
							self.radar.expected = text
		}
	}

	func actualTapped() {
		showEnterDetails(title: Localizable.Radar.actual.localized,
		                 content: radar.actual,
		                 placeholder: Localizable.Radar.Placeholder.actual.localized) { [unowned self] (text) in
							self.radar.actual = text
		}
	}

	func notesTapped() {
		showEnterDetails(title: Localizable.Radar.notes.localized,
		                 content: radar.notes,
		                 placeholder: Localizable.Radar.Placeholder.notes.localized) { [unowned self] (text) in
							self.radar.notes = text
		}
	}

	func attachmentsTapped() {
	}

	func submitTapped() {
		api.file(radar: radar.createRadar())
	}

	func cancelTapped() {
		finish()
	}
}


// MARK: - UIPopoverPresentationControllerDelegate Methods

extension RadarCoordinator: UIPopoverPresentationControllerDelegate {

	func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
		if let selected = radarViewController?.tableView.indexPathForSelectedRow {
			radarViewController?.tableView.deselectRow(at: selected, animated: true)
		}
	}
}
