import UIKit
import InterfaceBacked
import Sonar

protocol RadarViewDelegate: class {
	func controller(_ controller: RadarViewController, didSelectChoice choice: Choice, ofAll choices: [Choice], title: String)
	func controller(_ controller: RadarViewController, didSelectProperty property: String, with value: String, placeholder: String?)
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
	var product = Product.iOS
	var area = Area.areas(for: .iOS).first!
	var version = ""
	var classification = Classification.Security
	var reproducibility = Reproducibility.Always
	var configuration = ""
	var radarTitle = ""
	var radarDescription = ""
	var steps = ""
	var expected = ""
	var actual = ""
	var notes = ""
	var attachments = [Attachment]()


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
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { preconditionFailure() }

		var left = ""
		var right = ""
		var rightPlaceholder: String?

		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				left = NSLocalizedString("Radar.Product", comment: "")
				right = product.name
			case 1:
				left = NSLocalizedString("Radar.Area", comment: "")
				right = area.name
			case 2:
				left = NSLocalizedString("Radar.Version", comment: "")
				right = version
			case 3:
				left = NSLocalizedString("Radar.Classification", comment: "")
				right = classification.name
			case 4:
				left = NSLocalizedString("Radar.Reproducibility", comment: "")
				right = reproducibility.name
			case 5:
				left = NSLocalizedString("Radar.Configuration", comment: "")
				right = configuration
				rightPlaceholder = NSLocalizedString("Global.Optional", comment: "")
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0:
				left = NSLocalizedString("Radar.Title", comment: "")
				right = radarTitle
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 1:
				left = NSLocalizedString("Radar.Description", comment: "")
				right = radarDescription
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 2:
				left = NSLocalizedString("Radar.Steps", comment: "")
				right = steps
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 3:
				left = NSLocalizedString("Radar.Expected", comment: "")
				right = expected
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 4:
				left = NSLocalizedString("Radar.Actual", comment: "")
				right = actual
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			case 5:
				left = NSLocalizedString("Radar.Notes", comment: "")
				right = notes
				rightPlaceholder = NSLocalizedString("Global.Required", comment: "")
			default: break
			}
		case 2:
			left = NSLocalizedString("Radar.Attachment", comment: "")
			right = "No attachments"

		default: break
		}

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
		let cell = tableView.cellForRow(at: indexPath)
		guard let text = cell?.textLabel?.text else { return }
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0: delegate?.controller(self, didSelectChoice: product, ofAll: Product.All, title: text)
			case 1: delegate?.controller(self, didSelectChoice: area, ofAll: Area.areas(for: product), title: text)
			case 2: delegate?.controller(self, didSelectProperty: text, with: version, placeholder: nil)
			case 3: delegate?.controller(self, didSelectChoice: classification, ofAll: Classification.All, title: text)
			case 4: delegate?.controller(self, didSelectChoice: reproducibility, ofAll: Reproducibility.All, title: text)
			case 5: delegate?.controller(self, didSelectProperty: NSLocalizedString("Radar.Configuration", comment: ""), with: configuration, placeholder: NSLocalizedString("Global.Optiona", comment: ""))
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0: delegate?.controller(self, didSelectProperty: text, with: radarTitle, placeholder: nil)
			case 1: delegate?.controller(self, didSelectProperty: text, with: radarDescription, placeholder: NSLocalizedString("Radar.Description.Placeholder", comment: ""))
			case 2: delegate?.controller(self, didSelectProperty: text, with: steps, placeholder: NSLocalizedString("Radar.Steps.Placeholder", comment: ""))
			case 3: delegate?.controller(self, didSelectProperty: text, with: expected, placeholder: NSLocalizedString("Radar.Expected.Placeholder", comment: ""))
			case 4: delegate?.controller(self, didSelectProperty: text, with: actual, placeholder: NSLocalizedString("Radar.Actual.Placeholder", comment: ""))
			case 5: delegate?.controller(self, didSelectProperty: text, with: notes, placeholder: NSLocalizedString("Radar.Notes.Placeholder", comment: ""))
			default: break
			}
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
