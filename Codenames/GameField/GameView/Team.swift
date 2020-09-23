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
        case .systemRed: self = .redTeam
        case .systemBlue: self = .blueTeam
        default: return nil
        }
    }
    var rawValue: RawValue {
        switch self {
        case .redTeam: return .systemRed
        case .blueTeam: return .systemBlue
        }
    }
}
