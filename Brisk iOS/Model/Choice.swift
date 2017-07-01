import Foundation
import Sonar

protocol Choice {
	var name: String { get }
}

extension Product: Choice {}
extension Area: Choice {}
extension Classification: Choice {}
extension Reproducibility: Choice {}
