import Foundation

final class Token {

	let value: String

	init(_ value: String) {
		self.value = value
	}

	var isValid: Bool {
		let pattern = "[\\w]{8}-[\\w]{4}-[\\w]{4}-[\\w]{4}-[\\w]{12}"
		let match = value.range(of: pattern, options: .regularExpression)
		return match != nil
	}
}
