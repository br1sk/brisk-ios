import UIKit
import InterfaceBacked

protocol SingleChoiceDelegate: class {
	func controller(_ controller: SingleChoiceViewController, didSelect choice: Choice)
}

final class SingleChoiceViewController: UITableViewController, StoryboardBacked {


	// MARK: - Properties
	var selected: Choice?
	var all: [Choice]?
	weak var delegate: SingleChoiceDelegate?


	// MARK: - UIViewController Methods

	override func viewDidLoad() {
		precondition(all != nil, "All choices must be set before the view controller is presented")
		precondition(all!.isNotEmpty, "All choices must not be empty")

		selected = all?.first
	}

	// MARK: - UITableViewController Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let all = self.all else { return 0 }
		return all.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { preconditionFailure() }
		guard let all = self.all else { preconditionFailure() }

		let choice = all[indexPath.row]
		cell.textLabel?.text = choice.name
		if let selected = self.selected, choice.name == selected.name {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let all = self.all else { return }
		let choice = all[indexPath.row]
		delegate?.controller(self, didSelect: choice)
	}
}
