import Foundation
import Sonar
import Alamofire

protocol APIObserver: class {
	func didStartLoading()
	func didFail(with error: SonarError)
	func didPostToAppleRadar()
	func didPostToOpenRadar()
}

protocol TwoFactorAuthenticationHandler: class {
	func askForCode(completion: @escaping (String) -> Void)
}

final class APIController {


	// MARK: - Properties

	weak var observer: APIObserver?
	weak var twoFactorHandler: TwoFactorAuthenticationHandler?

	// MARK: - Init/Deinit

	init(withObserver observer: APIObserver? = nil, twoFactorHandler: TwoFactorAuthenticationHandler? = nil) {
		self.observer = observer
		self.twoFactorHandler = twoFactorHandler
	}


	// MARK: - Duping

	func search(forRadarWithId id: String, loading: @escaping (Bool) -> Void, success: @escaping (Radar) -> Void, failure: @escaping (String, String) -> Void) {

		// Fetch existing radar
		guard let url = URL(string: "https://openradar.appspot.com/api/radar?number=\(id)") else {
			preconditionFailure()
		}

		loading(true)

		Alamofire.request(url)
			.validate()
			.responseJSON { result in

				loading(false)

				if let error = result.error {
					failure("Error", error.localizedDescription)
					return
				}

				guard let json = result.value as? [String: Any], let result = json["result"] as? [String: Any], !result.isEmpty else {
					failure("No OpenRadar found", "Couldn't find an OpenRadar with ID #\(id)")
					return
				}

				guard let radar = try? Radar(openRadar: json) else {
					failure("Invalid OpenRadar", "OpenRadar is missing required fields")
					return
				}

				success(radar)

				// Continue to radar view controller
		}
	}


	// MARK: - Filing

	func file(radar: Radar) {
		guard let (username, password) = Keychain.get(.radar) else {
			preconditionFailure("Shouldn't be able to submit a radar without credentials")
		}

		observer?.didStartLoading()

		// Post to open radar

		// Hide loading

		// Success

		let handleTwoFactorAuth: (@escaping (String?) -> Void) -> () = { [weak self] closure in
			self?.twoFactorHandler?.askForCode(completion: closure)
		}

		var radar = radar

		let appleRadar = Sonar(service: .appleRadar(appleID: username, password: password))
		appleRadar.loginThenCreate(radar: radar, getTwoFactorCode: handleTwoFactorAuth) { [weak self] result in
			switch result {
			case .success(let radarID):
				guard let (_, token) = Keychain.get(.openRadar) else {
					self?.observer?.didPostToAppleRadar()
					return
				}

				radar.ID = radarID
				let openRadar = Sonar(service: .openRadar(token: token))
				openRadar.loginThenCreate(
					radar: radar, getTwoFactorCode: { closure in
						assertionFailure("Didn't handle Open Radar two factor")
						closure(nil)
				}) { [weak self] result in
					switch result {
					case .success:
						self?.observer?.didPostToAppleRadar()
						self?.observer?.didPostToOpenRadar()
					case .failure(let error):
						self?.observer?.didFail(with: error)
					}
				}
			case .failure(let error):
				self?.observer?.didFail(with: error)
			}
		}
	}
}
