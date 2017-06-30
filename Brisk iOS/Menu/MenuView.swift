import UIKit

final class MenuView: UIView {


	// MARK: - Properties

	let dupeButton: UIButton
	let fileButton: UIButton


	// MARK: - Init/Deinit

	override init(frame: CGRect) {
		dupeButton = UIButton()
		dupeButton.translatesAutoresizingMaskIntoConstraints = false
		dupeButton.setTitle("Dupe", for: .normal)
		fileButton = UIButton()
		fileButton.translatesAutoresizingMaskIntoConstraints = false
		fileButton.setTitle("File", for: .normal)
		super.init(frame: frame)

		let stack = UIStackView(arrangedSubviews: [dupeButton, fileButton])
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.spacing = 24.0
		addSubview(stack)

		NSLayoutConstraint.activate([
			stack.centerXAnchor.constraint(equalTo: centerXAnchor),
			stack.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
