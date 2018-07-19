import UIKit

public enum QuickAction {
    enum Radar: String {
        case new = "new-radar"
        case duplicate = "duplicate-radar"
    }
}

public extension QuickAction {
    struct Shortcut {
        static var new: UIApplicationShortcutItem {
            let icon = UIApplicationShortcutIcon(templateImageName: "Compose")

            return UIApplicationShortcutItem(type: "new-radar",
                                             localizedTitle: Localizable.QuickAction.newRadar.localized,
                                             localizedSubtitle: nil,
                                             icon: icon)
        }

        static var duplicate: UIApplicationShortcutItem {
            let icon = UIApplicationShortcutIcon(templateImageName: "Duplicate")

            return UIApplicationShortcutItem(type: "duplicate-radar",
                                             localizedTitle: Localizable.QuickAction.duplicateRadar.localized,
                                             localizedSubtitle: nil,
                                             icon: icon)
        }
    }
}
