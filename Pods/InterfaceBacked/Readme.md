# Interface Backed

[![Carthage
compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Original idea and implementation by [Benjamin Sandofsky's
gist](https://gist.github.com/sandofsky/0a8b5977afb16af1c6083fe97f0ac867)

I just simplified the code a bit and put it in a Framework. Added a similar
approach for `UIView` subclasses that rely on a `.nib` file. 

Released under the [MIT license](LICENSE)

## Usage

Your classes must be declared `final` to adopt the protocol.

### UIViewController

```
final class ViewController: UIViewController, StoryboardBacked {}

let vc = ViewController.newFromStoryboard()
```

You can use a custom name or a custom bundle. The function defaults to
a storyboard named as the view controller and to the bundle the class is in. So
this works even when your view controller class in inside a framework and not
the main bundle.

*Hint*: Double check that you made your custom view controller the initial view
controller for the storyboard.

### UITableViewCell

```
final class Cell: UITableViewCell, NibBackedCell {}

tableView.registerNib(Cell.cellNib(), forCellReuseIdentifier: Cell.identifier())
```

*Hint*: Double check the identifier for the cell in the `.nib` file. It must
reflect the name of the class.

For more information check the included Example target. 
