import UIKit
import InterfaceBacked

protocol MenuViewDelegate: class {
	func dupeTapped()
	func fileTapped()
	func settingsTapped()
}

final class MenuViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	weak var delegate: MenuViewDelegate?


	// MARK: - UIViewController Methods

	// MARK: - User Actions

	@IBAction func dupeButtonTapped() {
		delegate?.dupeTapped()
	}

	@IBAction func fileButtonTapped() {
		delegate?.fileTapped()
	}

	@IBAction func settingsTapped() {
		delegate?.settingsTapped()
	}
}
