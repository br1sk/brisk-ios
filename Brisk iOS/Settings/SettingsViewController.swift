import UIKit
import InterfaceBacked

protocol SettingsDelegate: class {
	func doneTapped()
	func clearOpenradarTapped()
	func logoutTapped()
	func frameworksTapped()
	func feedbackTapped()
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
	@IBOutlet weak var versionLabel: UILabel!


	// MARK: - UIViewController Methods

	override func viewDidLoad() {
		configureVersionLabel()
	}

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
					cell.textLabel?.textColor = UIColor.darkText
					cell.detailTextLabel?.textColor = view.tintColor
				} else {
					cell.detailTextLabel?.text = NSLocalizedString("Settings.OpenradarPlaceholder", comment: "")
					cell.detailTextLabel?.textColor = UIColor.lightGray
					cell.textLabel?.textColor = UIColor.lightGray
				}
			default: break
			}
		default: break
		}
	}

	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		if indexPath.section == aboutSection { return true }
		let cell = tableView.cellForRow(at: indexPath)
		guard let text = cell?.detailTextLabel?.text else { return false }
		return text != NSLocalizedString("Settings.OpenradarPlaceholder", comment: "") || text != NSLocalizedString("Settings.AppleRadarPlaceholder", comment: "")
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case accountSection:
			switch indexPath.row {
			case appleRow:
				showSheet(title: NSLocalizedString("Settings.AppleRadar.Confirm", comment: ""),
				          message: NSLocalizedString("Settings.AppleRadar.Message", comment: ""),
				          deleteTitle: NSLocalizedString("Settings.AppleRadar.Logout", comment: ""),
				          destructiveAction: {
							self.delegate?.logoutTapped()
				})
			case openradarRow:
				showSheet(title: NSLocalizedString("Settings.Openradar.Confirm", comment: ""),
				          message: NSLocalizedString("Settings.Openradar.Message", comment: ""),
				          deleteTitle: NSLocalizedString("Settings.Openradar.Clear", comment: ""),
				          destructiveAction: {
							self.delegate?.clearOpenradarTapped()
				})
			default: break
			}
		case aboutSection:
			switch indexPath.row {
			case thirdPartyRow: delegate?.frameworksTapped()
			case feedbackRow: delegate?.feedbackTapped()
			default: break
			}
		default: break
		}
	}


	// MARK: - Private

	private func showSheet(title: String, message: String, deleteTitle: String, destructiveAction: @escaping () -> Void) {
		let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		sheet.addAction(UIAlertAction(title: deleteTitle, style: .destructive, handler: { _ in
			destructiveAction()
			if let selected = self.tableView.indexPathForSelectedRow {
				self.tableView.deselectRow(at: selected, animated: true)
			}
		}))
		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
			sheet.dismiss(animated: true)
			if let selected = self.tableView.indexPathForSelectedRow {
				self.tableView.deselectRow(at: selected, animated: true)
			}
		}))
		present(sheet, animated: true, completion: nil)

		if let popover = sheet.popoverPresentationController, let selected = tableView.indexPathForSelectedRow {
			popover.sourceView = tableView
			popover.sourceRect = tableView.rectForRow(at: selected)
		}
	}

	private func configureVersionLabel() {
		guard let info = Bundle.main.infoDictionary, let versionString = info["CFBundleShortVersionString"], let buildVersionString = info["CFBundleVersion"] else { return }
		versionLabel.text = "Version \(versionString) (\(buildVersionString))"
	}
}
