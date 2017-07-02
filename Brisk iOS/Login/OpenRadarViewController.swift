import UIKit
import InterfaceBacked

protocol OpenRadarViewDelegate: class {
	func openSafariTapped()
	func continueTapped()
	func skipTapped()
}

final class OpenRadarViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var openSafariButton: UIButton!
	@IBOutlet weak var tokenField: UITextField!
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!
	weak var delegate: OpenRadarViewDelegate?

	let openSafariRow = 0
	let fieldRow = 1
	let finishRow = 2

	// MARK: - User Actions

	@IBAction func skipTapped() {delegate?.skipTapped() }


	// MARK: - UITableViewController Methods


	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		if indexPath.row == fieldRow { return false }
		return true
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case openSafariRow: delegate?.openSafariTapped()
		case finishRow: delegate?.continueTapped()
		default: break
		}
	}
}


// MARK: - UITextFieldDelegate Methods

extension OpenRadarViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
