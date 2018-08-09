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
    @IBOutlet var duplicateButton: UIButton!
    @IBOutlet var newButton: UIButton!
    @IBOutlet var settingsButton: UIButton!

	// MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        for button in [duplicateButton, newButton, settingsButton] {
            button?.layer.cornerRadius = 6
            button?.layer.masksToBounds = true
        }
    }

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
