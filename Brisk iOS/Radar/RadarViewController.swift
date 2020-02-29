import InterfaceBacked
import Sonar
import UIKit

protocol RadarViewDelegate: class {
	func productTapped()
	func areaTapped()
	func versionTapped()
	func classificationTapped()
	func reproducibilityTapped()
	func configurationTapped()

	func titleTapped()
	func descriptionTapped()
	func stepsTapped()
	func expectedTapped()
	func actualTapped()
	func notesTapped()
	func attachmentsTapped()

	func submitTapped()
	func cancelTapped()
}

final class RadarViewController: UITableViewController, StoryboardBacked, StatusDisplay {


	// MARK: - Properties

	weak var delegate: RadarViewDelegate?
	@IBOutlet weak var submitButton: UIButton!
	var allRequiredFieldsSet: Bool {
		// TODO: Determine required form fields
		return true
	}
	var radar: RadarViewModel? {
		didSet {
			tableView.reloadData()
		}
	}
	var duplicateOf = ""

	var didSelectProduct: (Product) -> Void = { _ in }

	// MARK: - User Actions

	@IBAction func submitTapped() {
		delegate?.submitTapped()
	}

	@IBAction func cancelTapped() {
		delegate?.cancelTapped()
	}


	// MARK: - UITableViewController Methods

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 2 { return 1 }
		return 6
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0, duplicateOf.isNotEmpty {
			return "Duplicating Radar #\(duplicateOf)"
		}
		return ""
	}

	// swiftlint:disable cyclomatic_complexity
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
            left = Localizable.Radar.product.localized
            right = radar.product.name
        case 1:
            left = Localizable.Radar.area.localized
            right = radar.area?.name ?? ""
            selectable = Area.areas(for: radar.product).isNotEmpty
        case 2:
            left = Localizable.Radar.version.localized
            right = radar.version
        case 3:
            left = Localizable.Radar.classification.localized
            right = radar.classification.name
        case 4:
            left = Localizable.Radar.reproducibility.localized
            right = radar.reproducibility.name
        case 5:
            left = Localizable.Radar.configuration.localized
            right = radar.configuration
            rightPlaceholder = Localizable.Global.optional.localized
        default: break
        }
		case 1:
            switch indexPath.row {
            case 0:
                left = Localizable.Radar.title.localized
                right = radar.title
                rightPlaceholder = Localizable.Global.required.localized
            case 1:
                left = Localizable.Radar.description.localized
                right = radar.description
                rightPlaceholder = Localizable.Global.required.localized
            case 2:
                left = Localizable.Radar.steps.localized
                right = radar.steps
                rightPlaceholder = Localizable.Global.required.localized
            case 3:
                left = Localizable.Radar.expected.localized
                right = radar.expected
                rightPlaceholder = Localizable.Global.required.localized
            case 4:
                left = Localizable.Radar.actual.localized
                right = radar.actual
                rightPlaceholder = Localizable.Global.required.localized
            case 5:
                left = Localizable.Radar.notes.localized
                right = radar.notes
                rightPlaceholder = Localizable.Global.required.localized
            default: break
            }
		case 2:
			left = Localizable.Radar.attachament.localized
			right = Localizable.Radar.noAttachaments.localized
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
			case 0: delegate?.productTapped()
			case 1: delegate?.areaTapped()
			case 2: delegate?.versionTapped()
			case 3: delegate?.classificationTapped()
			case 4: delegate?.reproducibilityTapped()
			case 5: delegate?.configurationTapped()
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0: delegate?.titleTapped()
			case 1: delegate?.descriptionTapped()
			case 2: delegate?.stepsTapped()
			case 3: delegate?.expectedTapped()
			case 4: delegate?.actualTapped()
			case 5: delegate?.notesTapped()
			default: break
			}
		case 2:
			delegate?.attachmentsTapped()
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
