import UIKit

enum Team {
    case redTeam
    case blueTeam
    
    func toString() -> String {
        switch self {
        case .redTeam: return "Red Team"
        case .blueTeam: return "Blue Team"
        }
    }
}

extension Team: RawRepresentable {
    typealias RawValue = UIColor
    init?(rawValue: RawValue) {
        switch rawValue {
        case Constants.redColor: self = .redTeam
        case Constants.blueColor: self = .blueTeam
        default: return nil
        }
    }
    var rawValue: RawValue {
        switch self {
        case .redTeam: return Constants.redColor
        case .blueTeam: return Constants.blueColor
        }
    }
}
