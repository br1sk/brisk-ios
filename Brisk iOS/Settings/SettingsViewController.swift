import UIKit
import InterfaceBacked

protocol SettingsDelegate: class {
	func doneTapped()
}

final class SettingsViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	let accountSection = 0
	let appleRow = 0
	let openradarRow = 1
	let aboutSection = 1
	let thirdPartyRow = 0
	let feedbackRow = 1
	weak var delegate: SettingsDelegate?

	let feedbackUrl = "https://github.com/florianbuerger/brisk-ios/issues/new"


	// MARK: - User Actions

	@IBAction func doneTapped() {
		delegate?.doneTapped()
	}

	// MARK: - UITableViewController Methods

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case accountSection:
			switch indexPath.row {
			case appleRow:
				if let (username, _) = Keychain.get(.radar) {
					cell.detailTextLabel?.text = username
					cell.detailTextLabel?.textColor = view.tintColor
				} else {
					cell.detailTextLabel?.text = NSLocalizedString("Settings.AppleRadarPlaceholder", comment: "")
					cell.detailTextLabel?.textColor = UIColor.lightGray
				}
			case openradarRow:
				if let (_, password) = Keychain.get(.openRadar) {
					cell.detailTextLabel?.text = password
					cell.detailTextLabel?.textColor = view.tintColor
				} else {
					cell.detailTextLabel?.text = NSLocalizedString("Settings.OpenradarPlaceholder", comment: "")
					cell.detailTextLabel?.textColor = UIColor.lightGray
				}
			default: break
			}
		default: break
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case accountSection:
			switch indexPath.row {
			case appleRow: print("Apple")
			case openradarRow: print("OpenRadar")
			default: break
			}
		case aboutSection:
			switch indexPath.row {
			case thirdPartyRow: print("Frameworks")
			case feedbackRow: UIApplication.shared.open(URL(string: feedbackUrl)!)
			default: break
			}
		default: break
		}
	}
}
