import UIKit
import InterfaceBacked

protocol DupeViewDelegate: class {
	func controllerDidCancel(_ controller: DupeViewController)
	func controller(_ controller: DupeViewController, didSubmit number: String)
}

final class DupeViewController: UIViewController, StoryboardBacked, StatusDisplay {


	// MARK: - Properties

	@IBOutlet weak var numberField: UITextField!
	@IBOutlet weak var hintLabel: UILabel!
	weak var delegate: DupeViewDelegate?


	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		if let content = UIPasteboard.general.string, content.isRadarNumber {
			numberField.text = content.extractRadarNumber()
			hintLabel.text = "Found \(content) on your clipboard"
		} else {
			hintLabel.text = "You can also post rdar:// or https://openradar.appspot.com/ links"
		}
	}

	// MARK: - User Actions

	@IBAction func submitTapped() {
		// TODO: Show error if invalid
		guard let text = numberField.text, text.isRadarNumber else { return }
		let number = text.extractRadarNumber() ?? ""
		delegate?.controller(self, didSubmit: number)
	}

	@IBAction func cancelTapped() {
		delegate?.controllerDidCancel(self)
	}

}


// MARK: - UITextFieldDelegate Methods

extension DupeViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
