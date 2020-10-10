import Foundation

final class TeamScore {
    // MARK: — Public Properties
    var redTeamScore: Int
    var blueTeamScore: Int
    
    // MARK: — Initializers
    init(redTeamScore: Int, blueTeamScore: Int) {
        self.redTeamScore = redTeamScore
        self.blueTeamScore = blueTeamScore
    }
}
