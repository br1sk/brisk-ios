import UIKit
import InterfaceBacked

final class EnterDetailsViewController: UIViewController, StoryboardBacked {


	// MARK: - Types

	enum Styling {
		case normal, placeholder
	}


	// MARK: - Properties

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textBottomSpaceConstraint: NSLayoutConstraint!
	var prefilledContent = ""
	var placeholder = ""
	var onDisappear: (String) -> Void = { _ in }

	
	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		textView.becomeFirstResponder()

		if placeholder.isNotEmpty && prefilledContent.isEmpty {
			applyStyling(.placeholder)
		} else {
			applyStyling(.normal)
			textView.text = prefilledContent
		}
	}


	override func viewWillDisappear(_ animated: Bool) {
		onDisappear(textView.text ?? "")
	}


	// MARK: - Private Methods

	fileprivate func moveCursorToStart() {
		DispatchQueue.main.async {
			self.textView.selectedRange = NSMakeRange(0, 0)
		}
	}

	fileprivate func applyStyling(_ styling: Styling) {
		switch styling {
		case .normal:
			textView.textColor = UIColor.darkText
		case .placeholder:
			textView.text = placeholder
			textView.textColor = UIColor.lightGray
		}
	}
}


// MARK: - UITextViewDelegate Methods

extension EnterDetailsViewController: UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == placeholder {
			moveCursorToStart()
		}
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let length = textView.text.characters.count + text.characters.count - range.length
		if length > 0 {
			if textView.text == placeholder {
				applyStyling(.normal)
				textView.text = ""
			}
			return true
		} else {
			applyStyling(.placeholder)
			moveCursorToStart()
			return false
		}
	}
}
