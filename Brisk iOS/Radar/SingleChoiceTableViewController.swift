import UIKit
import InterfaceBacked
import Sonar

final class SingleChoiceViewController<T: Choice>: UITableViewController {


	// MARK: - Properties
	var selected: T?
	var all: [T]?
	var radar: Radar?
	var onSelect: (T) -> Void = { _ in }

	// MARK: - UIViewController Methods

	override func viewDidLoad() {
		precondition(all != nil, "All choices must be set before the view controller is presented")
		precondition(all!.isNotEmpty, "All choices must not be empty")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.rowHeight = 44
	}

	override var preferredContentSize: CGSize {
		get {
			return CGSize(width: tableView.contentSize.width, height: tableView.rowHeight * CGFloat(tableView.numberOfRows(inSection: 0)))
		}
		set { super.preferredContentSize = newValue }
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
		onSelect(choice)
	}


}
