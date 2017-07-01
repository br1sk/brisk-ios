import Foundation
import Sonar
import Alamofire

final class APIController {


	// MARK: - Login


	func login(with user: User) {

	}

	// MARK: - Duping

	func dupe(radarWithId id: String, postToOpenRadar: Bool = false) {
		// Fetch existing radar
		guard let url = URL(string: "https://openradar.appspot.com/api/radar?number=\(id)") else {
			preconditionFailure()
		}
		Alamofire.request(url)
			.validate()
			.responseJSON { [weak self] result in
//				setLoading(false)

				if let error = result.error {
//					self?.show(NSAlert(error: error))
					return
				}

				guard let json = result.value as? [String: Any],
					let result = json["result"] as? [String: Any], !result.isEmpty else
				{
//					self?.showError(title: "No OpenRadar found",
//					                message: "Couldn't find an OpenRadar with ID #\(id)")
					return
				}

				guard let radar = try? Radar(openRadar: json) else
//					let document = NSDocumentController.shared().makeRadarDocument() else
				{
//					self?.showError(title: "Invalid OpenRadar",
//					                message: "OpenRadar is missing required fields")
					return
				}

//				document.makeWindowControllers(for: radar)
//				NSDocumentController.shared().addDocument(document)
//				document.showWindows()

//				self?.view.window?.windowController?.close()
		}
		// Amend description
		// Create new radar
		// Post to open radar
	}


	// MARK: - Filing
}
