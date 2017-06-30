import Foundation

final class Email {

	let string: String

	init(with string: String) {
		self.string = string
	}

	var isValid: Bool {
		return true
	}
}
