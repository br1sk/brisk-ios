import UIKit
import InterfaceBacked

protocol RadarViewDelegate: class {
	func controller(_ controller: RadarViewController, didSelectTitle title: String, placeholder: String?)
	func controllerDidSubmit(_ controller: RadarViewController)
}

final class RadarViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	weak var delegate: RadarViewDelegate?


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
				right = "iOS + SDK"
			case 1:
				left = NSLocalizedString("Radar.Area", comment: "")
				right = "UIKit"
			case 2:
				left = NSLocalizedString("Radar.Version", comment: "")
				right = "10.2"
			case 3:
				left = NSLocalizedString("Radar.Classification", comment: "")
				right = "Security"
			case 4:
				left = NSLocalizedString("Radar.Reproducibility", comment: "")
				right = "Always"
			case 5:
				left = NSLocalizedString("Radar.Configuration", comment: "")
				rightPlaceholder = "optional"
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0:
				left = NSLocalizedString("Radar.Title", comment: "")
			case 1:
				left = NSLocalizedString("Radar.Description", comment: "")
				rightPlaceholder = NSLocalizedString("Radar.Description.Placeholder", comment: "")
			case 2:
				left = NSLocalizedString("Radar.Steps", comment: "")
				rightPlaceholder = NSLocalizedString("Radar.Steps.Placeholder", comment: "")
			case 3:
				left = NSLocalizedString("Radar.Expected", comment: "")
				rightPlaceholder = NSLocalizedString("Radar.Expected.Placeholder", comment: "")
			case 4:
				left = NSLocalizedString("Radar.Actual", comment: "")
				rightPlaceholder = NSLocalizedString("Radar.Actual.Placeholder", comment: "")
			case 5:
				left = NSLocalizedString("Radar.Notes", comment: "")
				rightPlaceholder = NSLocalizedString("Radar.Notes.Placeholder", comment: "")
			default: break
			}
		case 2:
			left = NSLocalizedString("Radar.Attachment", comment: "")
			right = "No attachments"

		default: break
		}

		cell.textLabel?.text = left
		if let placeholder = rightPlaceholder, placeholder.isNotEmpty {
			cell.detailTextLabel?.text = rightPlaceholder
			cell.detailTextLabel?.textColor = UIColor.lightGray
		} else {
			cell.detailTextLabel?.text = right
			cell.detailTextLabel?.textColor = view.tintColor
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let title = "Something"
		delegate?.controller(self, didSelectTitle: title, placeholder: nil)
	}
}
