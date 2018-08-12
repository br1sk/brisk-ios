import InterfaceBacked
import UIKit

protocol OpenRadarViewDelegate: class {
	func openSafariTapped()
	func continueTapped(token: String)
	func skipTapped()
}

final class OpenRadarViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var tokenField: UITextField!
	weak var delegate: OpenRadarViewDelegate?

	let openSafariRow = 0
	let fieldRow = 1
	let finishRow = 2


	// MARK: - User Actions

	@IBAction func skipTapped() { delegate?.skipTapped() }


	// MARK: - UITableViewController Methods

	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		switch indexPath.row {
		case fieldRow: return false
		case finishRow:
			let token = tokenField.text ?? ""
			let validator = Token(token)
			return validator.isValid
		default: return true
		}
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let selectable = self.tableView(tableView, shouldHighlightRowAt: indexPath)
		cell.contentView.alpha = selectable || indexPath.row == fieldRow ? 1.0 : 0.5
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case openSafariRow: delegate?.openSafariTapped()
		case finishRow: delegate?.continueTapped(token: tokenField.text ?? "")
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
