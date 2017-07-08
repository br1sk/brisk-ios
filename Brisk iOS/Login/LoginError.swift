import Foundation

enum LoginError: Error {
	case invalidEmail
}
extension LoginError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidEmail:
            return Localizable.Login.Error.invalidEmail.localized
		}
	}
}
