import UIKit

final class TwoFactorAuthentication: TwoFactorAuthenticationHandler {


	// MARK: - Properties

	let viewController: UIViewController


	// MARK: - Init/Deinit

	init(viewController: UIViewController) {
		self.viewController = viewController
	}

	func askForCode(completion: @escaping (String) -> Void) {
		let alert = UIAlertController(title: Localizable.Radar.TwoFactor.title.localized, message: Localizable.Radar.TwoFactor.message.localized, preferredStyle: .alert)
		alert.addTextField { (field) in
			field.keyboardType = .numberPad
			let bodyDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
			field.font = UIFont(descriptor: bodyDescriptor, size: bodyDescriptor.pointSize)
			field.autocorrectionType = .no
			field.enablesReturnKeyAutomatically = true
		}
		alert.addAction(UIAlertAction(title: Localizable.Radar.TwoFactor.submit.localized, style: .default, handler: { _ in
			guard let field = alert.textFields?.first else { preconditionFailure() }
			guard let text = field.text, text.isNotEmpty else {
				alert.dismiss(animated: true) {
					self.askForCode(completion: completion)
				}
				return
			}
			completion(text)
		}))
		viewController.present(alert, animated: true)
	}

}
