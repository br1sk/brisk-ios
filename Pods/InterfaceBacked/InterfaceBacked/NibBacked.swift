import UIKit

public protocol NibBacked: class {
    
    static func newFromNib() -> Self
    
    static func newFromNib(withName name:String) -> Self
    
    static func newFromNib(withName name:String, bundle:Bundle) -> Self
    
    static func newFromNib(withName name:String, bundle:Bundle, owner: AnyObject?, options: [NSObject : AnyObject]?) -> Self
}

public extension NibBacked {
    
    static func newFromNib() -> Self {
        return newFromNib(withName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    static func newFromNib(withName name:String) -> Self {
        return newFromNib(withName: name, bundle: Bundle(for: Self.self))
    }
    
    static func newFromNib(withName name:String, bundle:Bundle) -> Self {
        return newFromNib(withName: name, bundle: bundle, owner: nil, options: nil)
    }
    
    static func newFromNib(withName name: String, bundle: Bundle, owner: AnyObject?, options: [NSObject : AnyObject]?) -> Self {
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: owner, options: options).first as! Self
        return view
    }
}

public protocol NibBackedCell: class {
    
    static var cellNib: UINib { get }
    
    static func cellNib(inBundle bundle: Bundle) -> UINib
    
    static var identifier: String { get }
}

public extension NibBackedCell {
    
    static var cellNib: UINib {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle(for: Self.self))
        return nib
    }

    static func cellNib(inBundle bundle: Bundle = Bundle(for: Self.self)) -> UINib {
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib
    }

    static var identifier: String {
        return String(describing: self)
    }
}
