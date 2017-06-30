import UIKit

protocol MenuViewDelegate: class {
	func dupeTapped()
	func fileTapped()
}

final class MenuViewController: UIViewController {


	// MARK: - Properties

	weak var delegate: MenuViewDelegate?

	// MARK: - UIViewController Methods

	override func loadView() {
		let view = MenuView()
		view.dupeButton.addTarget(self, action: #selector(MenuViewController.dupeButtonTapped), for: .primaryActionTriggered)
		view.fileButton.addTarget(self, action: #selector(MenuViewController.fileButtonTapped), for: .primaryActionTriggered)
		self.view = view
	}


	// MARK: - User Actions

	@objc func dupeButtonTapped() {
		delegate?.dupeTapped()
	}

	@objc func fileButtonTapped() {
		delegate?.fileTapped()
	}
}
