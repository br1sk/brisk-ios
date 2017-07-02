import UIKit
import InterfaceBacked
import Sonar

protocol RadarViewDelegate: class {
	func controllerDidSelectProduct(_ controller: RadarViewController)
	func controllerDidSelectArea(_ controller: RadarViewController)
	func controllerDidSelectVersion(_ controller: RadarViewController)
	func controllerDidSelectClassification(_ controller: RadarViewController)
	func controllerDidSelectReproducibility(_ controller: RadarViewController)
	func controllerDidSelectConfiguration(_ controller: RadarViewController)

	func controllerDidSelectTitle(_ controller: RadarViewController)
	func controllerDidSelectDescription(_ controller: RadarViewController)
	func controllerDidSelectSteps(_ controller: RadarViewController)
	func controllerDidSelectExpected(_ controller: RadarViewController)
	func controllerDidSelectActual(_ controller: RadarViewController)
	func controllerDidSelectNotes(_ controller: RadarViewController)
	func controllerDidSelectAttachments(_ controller: RadarViewController)

	func controllerDidSubmit(_ controller: RadarViewController)
}

final class RadarViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	weak var delegate: RadarViewDelegate?
	@IBOutlet weak var submitButton: UIButton!
	var allRequiredFieldsSet: Bool {
		// TODO: Determine required form fields
		return true
	}
	var radar: RadarCoordinator.ViewModel? {
		didSet {
			tableView.reloadData()
		}
	}

	var didSelectProduct: (Product) -> Void = { _ in }

	var product: Product = .iOS { didSet { tableView.reloadData() } }
	var area = Area.areas(for: .iOS).first  { didSet { tableView.reloadData() } }

	// MARK: - User Actions

	@IBAction func submitTapped() {
		delegate?.controllerDidSubmit(self)
	}


	// MARK: - UITableViewController Methods

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 2 { return 1 }
		return 6
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell"), let radar = self.radar else { preconditionFailure() }
		var left = ""
		var right = ""
		var rightPlaceholder: String?
		var selectable = true

		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				left = NSLocalizedString("Radar.Product", comment: "")
				right = radar.product.name
			case 1:
				left = NSLocalizedString("Radar.Area", comment: "")
				right = radar.area?.name ?? ""
				selectable = Area.areas(for: radar.product).isNotEmpty
			case 2:
				left = NSLocalizedString("Radar.Version", comment: "")
				right = radar.version
			case 3:
				left = NSLocalizedString("Radar.Classification", comment: "")
				right = radar.classification.name
			case 4:
				left = NSLocalizedString("Radar.Reproducibility", comment: "")
				right = radar.reproducibility.name
			case 5:
				left = NSLocalizedString("Radar.Configuration", comment: "")
				right = radar.configuration
				rightPlaceholder = NSLocalizedString("Global.Optional", comment: "")
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0:
				left = NSLocalizedString("Radar.Title", comment: "")
				right = radar.title
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 1:
				left = NSLocalizedString("Radar.Description", comment: "")
				right = radar.description
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 2:
				left = NSLocalizedString("Radar.Steps", comment: "")
				right = radar.steps
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 3:
				left = NSLocalizedString("Radar.Expected", comment: "")
				right = radar.expected
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 4:
				left = NSLocalizedString("Radar.Actual", comment: "")
				right = radar.actual
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 5:
				left = NSLocalizedString("Radar.Notes", comment: "")
				right = radar.notes
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			default: break
			}
		case 2:
			left = NSLocalizedString("Radar.Attachment", comment: "")
			right = "No attachments"
			selectable = false // not implemented yet

		default: break
		}

		cell.selectionStyle = (selectable) ? .blue : .none
		cell.textLabel?.textColor = (selectable) ? UIColor.darkText : UIColor.lightGray

		cell.textLabel?.text = left
		if right.isNotEmpty {
			cell.detailTextLabel?.text = right
			cell.detailTextLabel?.textColor = view.tintColor
		} else {
			cell.detailTextLabel?.text = rightPlaceholder
			cell.detailTextLabel?.textColor = UIColor.lightGray
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0: delegate?.controllerDidSelectProduct(self)
			case 1: delegate?.controllerDidSelectArea(self)
			case 2: delegate?.controllerDidSelectVersion(self)
			case 3: delegate?.controllerDidSelectClassification(self)
			case 4: delegate?.controllerDidSelectReproducibility(self)
			case 5: delegate?.controllerDidSelectConfiguration(self)
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0: delegate?.controllerDidSelectTitle(self)
			case 1: delegate?.controllerDidSelectDescription(self)
			case 2: delegate?.controllerDidSelectSteps(self)
			case 3: delegate?.controllerDidSelectExpected(self)
			case 4: delegate?.controllerDidSelectActual(self)
			case 5: delegate?.controllerDidSelectNotes(self)
			default: break
			}
		case 2:
			delegate?.controllerDidSelectAttachments(self)
		default:
			break
		}

	}


	// MARK: - Private Methods

	private func validateSubmitButton() {
		if allRequiredFieldsSet {
			submitButton.isEnabled = true
			navigationItem.rightBarButtonItem?.isEnabled = true
		} else {
			submitButton.isEnabled = false
			navigationItem.rightBarButtonItem?.isEnabled = false
		}
	}
}
