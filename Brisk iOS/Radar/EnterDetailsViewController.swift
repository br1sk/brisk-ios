import UIKit
import InterfaceBacked

final class EnterDetailsViewController: UIViewController, StoryboardBacked {


	// MARK: - Properties

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textBottomSpaceConstraint: NSLayoutConstraint!
	var prefilledContent: String = ""
	var placeholder: String?

	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		textView.becomeFirstResponder()

		if let placeholder = self.placeholder, placeholder.isNotEmpty {
			textView.text = placeholder
			textView.textColor = UIColor.lightGray
		} else {
			textView.text = prefilledContent
			textView.textColor = UIColor.darkText
		}
	}
}
