import Foundation
import UIKit
import Sonar

// FIXME: This grew fast. Extract stuff...

final class RadarCoordinator: NSObject {


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
	lazy var api: APIController = {
		return APIController(withObserver: self, twoFactorHandler: self)
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
			self.radar = ViewModel(radar)
			controller.duplicateOf = duplicateOf
			controller.title = NSLocalizedString("RadarView.Title.Duplicate", comment: "")
		} else {
			controller.title = NSLocalizedString("RadarView.Title.New", comment: "")
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
		radar = ViewModel()
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
		showEnterDetails(title: NSLocalizedString("Radar.Version", comment: ""), content: radar.version, placeholder: "") { [unowned self] (text) in
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
		showEnterDetails(title: NSLocalizedString("Radar.Configuration", comment: ""), content: radar.configuration, placeholder: "") { [unowned self] (text) in
			self.radar.configuration = text
		}
	}

	func titleTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Title", comment: ""), content: radar.title, placeholder: "") { [unowned self] (text) in
			self.radar.title = text
		}
	}

	func descriptionTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Description", comment: ""),
		                 content: radar.description,
		                 placeholder: NSLocalizedString("Radar.Description.Placeholder", comment: "")) { [unowned self] (text) in
			self.radar.description = text
		}
	}

	func stepsTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Steps", comment: ""),
		                 content: radar.steps,
		                 placeholder: NSLocalizedString("Radar.Steps.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.steps = text
		}
	}

	func expectedTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Expected", comment: ""),
		                 content: radar.expected,
		                 placeholder: NSLocalizedString("Radar.Expected.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.expected = text
		}
	}

	func actualTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Actual", comment: ""),
		                 content: radar.actual,
		                 placeholder: NSLocalizedString("Radar.Actual.Placeholder", comment: "")) { [unowned self] (text) in
							self.radar.actual = text
		}
	}

	func notesTapped() {
		showEnterDetails(title: NSLocalizedString("Radar.Notes", comment: ""),
		                 content: radar.notes,
		                 placeholder: NSLocalizedString("Radar.Notes.Placeholder", comment: "")) { [unowned self] (text) in
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

extension RadarCoordinator.ViewModel {

	init(_ radar: Radar) {
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

extension RadarCoordinator: APIObserver {
	func didStartLoading() {
		radarViewController?.showLoading()
	}

	func didFail(with error: SonarError) {
		radarViewController?.hideLoading()
		let alert = UIAlertController(title: NSLocalizedString("Global.Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("Global.Dismiss", comment: ""), style: .cancel))
		radarViewController?.present(alert, animated: true)
	}

	func didPostToAppleRadar() {
		radarViewController?.hideLoading()
		let delay = 3.0
		radarViewController?.showSuccess(message: NSLocalizedString("Radar.Post.Success", comment: ""), autoDismissAfter: delay)
	}

	func didPostToOpenRadar() {
		radarViewController?.hideLoading()
		radarViewController?.showSuccess(message: NSLocalizedString("Radar.Post.Success", comment: ""))
	}
}

extension RadarCoordinator: TwoFactorAuthenticationHandler {
	func askForCode(completion: @escaping (String) -> Void) {
		let alert = UIAlertController(title: NSLocalizedString("Radar.TwoFactorAuth.Title", comment: ""), message: NSLocalizedString("Radar.TwoFactorAuth.Message", comment: ""), preferredStyle: .alert)
		alert.addTextField { (field) in
			field.keyboardType = .numberPad
			let bodyDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
			field.font = UIFont(descriptor: bodyDescriptor, size: bodyDescriptor.pointSize)
			field.autocorrectionType = .no
			field.enablesReturnKeyAutomatically = true
		}
		alert.addAction(UIAlertAction(title: NSLocalizedString("Radar.TwoFactorAuth.Submit", comment: ""), style: .default, handler: { (action) in
			guard let field = alert.textFields?.first else { preconditionFailure() }
			guard let text = field.text, text.isNotEmpty else {
				self.askForCode(completion: completion)
				return
			}
			completion(text)
		}))
		radarViewController?.present(alert, animated: true)
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
