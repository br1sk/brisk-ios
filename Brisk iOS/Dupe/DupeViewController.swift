import UIKit
import InterfaceBacked

protocol DupeViewDelegate: class {
	func controllerDidCancel(_ controller: DupeViewController)
	func controller(_ controller: DupeViewController, didSubmit number: String)
}

final class DupeViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var numberField: UITextField!
	weak var delegate: DupeViewDelegate?

	// MARK: - User Actions

	@IBAction func submitTapped() {
		guard let number = numberField.text else { return }
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
