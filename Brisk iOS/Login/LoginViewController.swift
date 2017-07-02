import UIKit
import InterfaceBacked

protocol LoginViewDelegate: class {
	func submitTapped(user: User)
}


final class LoginViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	weak var delegate: LoginViewDelegate?


	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		emailField.becomeFirstResponder()

		#if DEBUG
		emailField.text = "foo@bar.baz"
		passwordField.text = "1234"
		#endif
		validateSubmitButton()
	}


	// MARK: - User Actions

	@IBAction func submitTapped() {
		guard let rawEmail = emailField.text, let password = passwordField.text else { return }
		let email = Email(rawEmail)
		let user = User(email: email, password: password)
		delegate?.submitTapped(user: user)
	}

	@IBAction func textFieldChanged() {
		validateSubmitButton()
	}


	// MARK: - Private

	private func validateSubmitButton() {
		if let email = emailField.text, email.isNotEmpty, let password = passwordField.text, password.isNotEmpty {
			submitButton.isEnabled = true
		} else {
			submitButton.isEnabled = false
		}
	}
}


// MARK: - Extension

extension LoginViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === emailField {
			textField.resignFirstResponder()
			passwordField.becomeFirstResponder()
		}
		if textField === passwordField {
			passwordField.resignFirstResponder()
			submitTapped()
		}
		return true
	}

}
