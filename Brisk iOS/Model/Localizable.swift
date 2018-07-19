import Foundation

public typealias Localize = String
protocol LocalizeRepresentable: RawRepresentable {
    var localized: String { get }
}


enum Localizable {
    enum Global: Localize, LocalizeRepresentable {
        case error      = "Global.Error"
        case tryAgain   = "Global.Error.TryAgain"
        case success    = "Global.Success"
        case failed     = "Global.Failed"
        case required   = "Global.Required"
        case optional   = "Global.Optional"
        case dismiss    = "Global.Dismiss"
        case cancel     = "Global.Cancel"
    }

    enum QuickAction: Localize, LocalizeRepresentable {
        case newRadar           = "QuickAction.NewRadar"
        case duplicateRadar     = "QuickAction.DuplicateRadar"
    }

    enum Login {
        enum Error: Localize, LocalizeRepresentable {
            case invalidEmail   = "LoginError.InvalidEmail"
        }
    }

    enum Radar: Localize, LocalizeRepresentable {
        case product            = "Radar.Product"
        case area               = "Radar.Area"
        case version            = "Radar.Version"
        case classification     = "Radar.Classification"
        case reproducibility    = "Radar.Reproducibility"
        case configuration      = "Radar.Configuration"
        case title              = "Radar.Title"
        case description        = "Radar.Description"
        case steps              = "Radar.Steps"
        case expected           = "Radar.Expected"
        case actual             = "Radar.Actual"
        case notes              = "Radar.Notes"
        case attachament        = "Radar.Attachment"
        case noAttachaments     = "Radar.Attachment.NoAttachments"

        enum Placeholder: Localize, LocalizeRepresentable {
            case description    = "Radar.Description.Placeholder"
            case steps          = "Radar.Steps.Placeholder"
            case expected       = "Radar.Expected.Placeholder"
            case actual         = "Radar.Actual.Placeholder"
            case notes          = "Radar.Notes.Placeholder"
        }

        enum View {
            enum Title: Localize, LocalizeRepresentable {
                case duplicate  = "RadarView.Title.Duplicate"
                case new        = "RadarView.Title.New"
            }
        }

        enum Post: Localize, LocalizeRepresentable {
            case success        = "Radar.Post.Success"
        }

        enum TwoFactor: Localize, LocalizeRepresentable {
            case title          = "Radar.TwoFactorAuth.Title"
            case message        = "Radar.TwoFactorAuth.Message"
            case submit         = "Radar.TwoFactorAuth.Submit"
        }
    }

    enum Settings {
        enum OpenRadar: Localize, LocalizeRepresentable {
            case placeholder    = "Settings.OpenradarPlaceholder"
            case confirm        = "Settings.Openradar.Confirm"
            case message        = "Settings.Openradar.Message"
            case clear          = "Settings.Openradar.Clear"
        }

        enum AppleRadar: Localize, LocalizeRepresentable {
            case placeholder    = "Settings.AppleRadarPlaceholder"
            case confirm        = "Settings.AppleRadar.Confirm"
            case message        = "Settings.AppleRadar.Message"
            case logout         = "Settings.AppleRadar.Logout"
        }
    }
}

extension LocalizeRepresentable where RawValue == Localize {
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
