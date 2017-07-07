import Foundation
import Sonar
import Alamofire

protocol APIDelegate: class {
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

	weak var delegate: APIDelegate?
	weak var twoFactorHandler: TwoFactorAuthenticationHandler?


	// MARK: - Init/Deinit

	init(delegate: APIDelegate? = nil, twoFactorHandler: TwoFactorAuthenticationHandler? = nil) {
		self.delegate = delegate
		self.twoFactorHandler = twoFactorHandler
	}


	// MARK: - Duping


	// TODO: Use delegate

	func search(forRadarWithId radarId: String, loading: @escaping (Bool) -> Void, success: @escaping (Radar) -> Void, failure: @escaping (String, String) -> Void) {

		// Fetch existing radar
		guard let url = URL(string: "https://openradar.appspot.com/api/radar?number=\(radarId)") else {
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
					failure("No OpenRadar found", "Couldn't find an OpenRadar with ID #\(radarId)")
					return
				}

				guard let radar = try? Radar(openRadar: json) else {
					failure("Invalid OpenRadar", "OpenRadar is missing required fields")
					return
				}

				success(radar)
		}
	}


	// MARK: - Filing

	func file(radar: Radar) {
		guard let (username, password) = Keychain.get(.radar) else {
			preconditionFailure("Shouldn't be able to submit a radar without credentials")
		}

		delegate?.didStartLoading()

		let handleTwoFactorAuth: (@escaping (String?) -> Void) -> Void = { [weak self] closure in
			self?.twoFactorHandler?.askForCode(completion: closure)
		}

		var radar = radar

		// Post to Apple Radar

		let appleRadar = Sonar(service: .appleRadar(appleID: username, password: password))
		appleRadar.loginThenCreate(radar: radar, getTwoFactorCode: handleTwoFactorAuth) { [weak self] result in
			switch result {
			case .success(let radarID):

				// Don't post to OpenRadar if no token is present.
				// TODO: Should we show a confirmation/login for OpenRadar?
				guard let (_, token) = Keychain.get(.openRadar) else {
					self?.delegate?.didPostToAppleRadar()
					return
				}

				// Post to open radar

				radar.ID = radarID
				let openRadar = Sonar(service: .openRadar(token: token))
				openRadar.loginThenCreate(
					radar: radar, getTwoFactorCode: { closure in
						assertionFailure("Didn't handle Open Radar two factor")
						closure(nil)
				}) { [weak self] result in
					switch result {
					case .success:
						self?.delegate?.didPostToAppleRadar()
						self?.delegate?.didPostToOpenRadar()
					case .failure(let error):
						self?.delegate?.didFail(with: error)
					}
				}
			case .failure(let error):
				self?.delegate?.didFail(with: error)
			}
		}
	}
}
