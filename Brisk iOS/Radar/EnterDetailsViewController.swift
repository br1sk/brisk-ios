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
		if placeholder.isNotEmpty && prefilledContent.isEmpty {
			applyStyling(.placeholder)
		} else {
			applyStyling(.normal)
			textView.text = prefilledContent
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		textView.becomeFirstResponder()
	}

	override func viewDidLoad() {
		let center = NotificationCenter.default
		center.addObserver(self, selector: #selector(EnterDetailsViewController.adjustForKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
		center.addObserver(self, selector: #selector(EnterDetailsViewController.adjustForKeyboard(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
	}

    override func viewWillDisappear(_ animated: Bool) {
        if placeholder.isEmpty ||
            textView.text != placeholder {
            onDisappear(textView.text)
        }
    }

	// MARK: - Private Methods

	@objc fileprivate func adjustForKeyboard(notification: NSNotification) {

		if notification.name == Notification.Name.UIKeyboardWillHide {
			textView.contentInset = UIEdgeInsets.zero
			textView.scrollIndicatorInsets = UIEdgeInsets.zero
		} else {
			// Text jumps around a bit, any idea how to avoid that?
			let info = notification.userInfo!
			guard let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
			let keyboardScreenEndFrame = value.cgRectValue
			let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

			let textFrame = view.window!.convert(textView.frame, from: view)
			let delta = UIScreen.main.bounds.maxY - textFrame.maxY
			let yInset = abs(delta - keyboardViewEndFrame.height)

			let margin = textView.font!.pointSize
			let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: yInset + margin, right: 0)
			textView.contentInset = contentInsets
			textView.scrollIndicatorInsets = UIEdgeInsets.zero

			let selectedRange = textView.selectedRange
			textView.scrollRangeToVisible(selectedRange)
		}
	}


	fileprivate func moveCursorToStart() {
		DispatchQueue.main.async {
			// swiftlint:disable:next legacy_constructor
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
