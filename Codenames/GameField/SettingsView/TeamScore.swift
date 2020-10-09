import Foundation

final class TeamScore {
    var redTeamScore: Int
    var blueTeamScore: Int
    
    init(redTeamScore: Int, blueTeamScore: Int) {
        self.redTeamScore = redTeamScore
        self.blueTeamScore = blueTeamScore
    }
    
    private func defineLider () -> Bool {
        return redTeamScore == 0 || blueTeamScore == 0
    }
}
