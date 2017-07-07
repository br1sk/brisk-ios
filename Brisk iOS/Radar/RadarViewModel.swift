import Foundation
import Sonar

struct RadarViewModel {
	var product: Product = .iOS
	var area: Area? = Area.areas(for: .iOS).first
	var classification: Classification = .Security
	var reproducibility: Reproducibility = .Always
	var title: String = ""
	var description: String = ""
	var steps: String = ""
	var expected: String = ""
	var actual: String = ""
	var configuration: String = ""
	var version: String = ""
	var notes: String = ""
	var attachments: [Attachment] = []
}


extension RadarViewModel {

	init(_ radar: Radar) {
		product = radar.product
		area = radar.area ?? Area.areas(for: product).first!
		classification = radar.classification
		reproducibility = radar.reproducibility
		title = radar.title
		description = radar.description
		steps = radar.steps
		expected = radar.expected
		actual = radar.actual
		configuration = radar.configuration
		version = radar.version
		notes = radar.notes
		attachments = radar.attachments
	}

	func createRadar() -> Radar {
		return Radar(
			classification: classification,
			product: product,
			reproducibility: reproducibility,
			title: title,
			description: description,
			steps: steps,
			expected: expected,
			actual: actual,
			configuration: configuration,
			version: version,
			notes: notes,
			attachments: attachments
		)
	}
}
