import UIKit
import InterfaceBacked

struct User {
	let email: Email
	let password: String
}

enum LoginError: Error {
	case invalidEmail
}
extension LoginError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidEmail: return NSLocalizedString("LoginError.InvalidEmail", comment: "")
		}
	}
}

protocol LoginViewDelegate: class {
	func controller(_ controller: LoginViewController, didSubmit user: User)
	func showError(_ error: LoginError)
}

final class LoginViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	weak var delegate: LoginViewDelegate?


	// MARK: - User Actions

	func submitTapped() {
		guard let rawEmail = emailField.text, let password = passwordField.text else { return }
		let email = Email(with: rawEmail)
		let user = User(email: email, password: password)
		delegate?.controller(self, didSubmit: user)
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
		}
		return true
	}
}
