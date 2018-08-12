import UIKit

protocol KeyboardObservable {
    func keyboardObservers() -> [Any]
    func removeObservers(_ observers: [Any])
}

extension KeyboardObservable where Self: UITextView {
    func keyboardObservers() -> [Any] {
        let observer1 = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        let observer2 = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
        return [observer1, observer2]
    }
    func removeObservers(_ observers: [Any]) {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    private var currentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        }
        return contentInset
    }
    private var textIsEmpty: Bool {
        switch text {
        case .some(let content):
            return content.isEmpty
        case .none:
            return true
        }
    }
    private var textHeight: CGFloat {
        guard let font = font else {
            fatalError("Can't calculate text height without a font.")
        }
        let size = (text ?? "").size(with: font, constrainedToWidth: frame.width)
        return size.height
    }
    private func keyboardWillShow(_ notification: Notification) {
        let viewPort = establishViewPort(.show, with: notification)
        adjust(viewPort)
    }
    private func keyboardWillHide(_ notification: Notification) {
        let viewPort = establishViewPort(.hide, with: notification)
        adjust(viewPort)
    }
    private typealias ViewPort = (height: CGFloat, offset: CGFloat, inset: UIEdgeInsets)
    private func establishViewPort(_ state: State, with notification: Notification) -> ViewPort {
        let height = self.height(for: state, with: notification)
        let offset: CGFloat
        var inset = currentInset
        switch state {
        case .show:
            offset = height
            inset.bottom = height
        case .hide:
            offset = -height
            inset.bottom = 0
        }
        return (height, offset, inset)
    }
    private func adjust(_ viewPort: ViewPort) {
        let height = viewPort.height
        let offset = viewPort.offset
        let inset = viewPort.inset
        if textHeight >= height {
            let contentOffset = CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + offset)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.contentInset = inset
                self.scrollIndicatorInsets = inset
                self.contentOffset = contentOffset
            }, completion: nil)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.contentInset = inset
                self?.scrollIndicatorInsets = inset
            }
        }
    }
    private func height(for state: State, with notification: Notification) -> CGFloat {
        guard
            let superview = superview,
            let window = superview.window,
            let font = font,
            let userInfo = notification.userInfo else {
                fatalError("Missing required superview, window, font & userInfo.")
        }
        let keyboardScreenFrame: CGRect
        switch state {
        case .show:
            guard let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                fatalError("No frame in userInfo found for key UIKeyboardFrameEndUserInfoKey")
            }
            keyboardScreenFrame = frame
        case .hide:
            guard let frame = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
                fatalError("No frame in userInfo found for key UIKeyboardFrameBeginUserInfoKey")
            }
            keyboardScreenFrame = frame
        }
        let textFrame = window.convert(frame, from: superview)
        let delta = UIScreen.main.bounds.maxY - textFrame.maxY
        let keyboardViewFrame = superview.convert(keyboardScreenFrame, from: window)
        let yInset = abs(delta - keyboardViewFrame.height)
        return yInset + font.pointSize
    }
}

private enum State {
    case show, hide
}

private extension String {
    func size(with font: UIFont, constrainedToWidth width: CGFloat) -> CGSize {
        let attString = NSAttributedString(string: self, attributes: [.font: font])
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        let range = CFRange(location: 0, length: 0)
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, size, nil)
    }
}
