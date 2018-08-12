import UIKit
import InterfaceBacked

final class TextView: UITextView, KeyboardObservable {
    private var observers: [Any]?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observers = keyboardObservers()
    }
    deinit {
        removeObservers(observers ?? [])
    }
}

final class EnterDetailsViewController: UIViewController, StoryboardBacked {

	// MARK: - Types

	enum Styling {
		case normal, placeholder
	}


	// MARK: - Properties

	@IBOutlet weak var textView: TextView!
	@IBOutlet weak var textBottomSpaceConstraint: NSLayoutConstraint!
	var prefilledContent = ""
	var placeholder = ""
	var onDisappear: (String) -> Void = { _ in }


	// MARK: - UIViewController Methods

	override func viewWillAppear(_ animated: Bool) {
		if placeholder.isNotEmpty && prefilledContent.isEmpty {
			applyStyling(.placeholder)
            textView.text = placeholder
		} else {
			applyStyling(.normal)
			textView.text = prefilledContent
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		textView.becomeFirstResponder()
	}

    override func viewWillDisappear(_ animated: Bool) {
        if placeholder.isEmpty ||
            textView.text != placeholder {
            onDisappear(textView.text)
        }
    }

	// MARK: - Private Methods

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
		let length = textView.text.count + text.count - range.length
		if length > 0 {
			if textView.text == placeholder {
				applyStyling(.normal)
                textView.text = ""
			}
		} else {
			applyStyling(.placeholder)
			moveCursorToStart()
		}
        return true
	}
}
