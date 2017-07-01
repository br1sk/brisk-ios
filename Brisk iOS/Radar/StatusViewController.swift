import UIKit
import InterfaceBacked

enum Status {
	case failed
	case success

	var visual: String {
		switch self {
		case .failed: return "💔"
		case .success: return "✅"
		}
	}
}
extension Status: CustomStringConvertible {
	var description: String {
		switch self {
		case .failed(_): return NSLocalizedString("Global.Failed", comment: "")
		case .success(_): return NSLocalizedString("Global.Success", comment: "")
		}
	}
}

final class StatusViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var emojiLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	var status = Status.success

	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		emojiLabel.text = status.visual
		messageLabel.text = status.description
	}
}
