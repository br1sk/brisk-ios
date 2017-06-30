import UIKit

final class LoginViewController: UIViewController {


	// MARK: - Properties

	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!


	// MARK: - UIViewController Methods

	override func viewDidLoad() {
		super.viewDidLoad()
	}

}


// MARK: - Extension

extension LoginViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === usernameField {
			textField.resignFirstResponder()
			passwordField.becomeFirstResponder()
		}
		if textField === passwordField {
			passwordField.resignFirstResponder()
		}
		return true
	}
}
