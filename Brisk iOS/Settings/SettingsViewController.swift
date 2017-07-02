import UIKit
import InterfaceBacked

final class SettingsViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	let accountSection = 0
	let appleRow = 1
	let openradarRow = 2
	let aboutSection = 1
	let thirdPartyRow = 0
	let feedbackRow = 1

	let feedbackUrl = "https://github.com/florianbuerger/brisk-ios/issues/new"

	// MARK: - UITableViewController Methods

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
