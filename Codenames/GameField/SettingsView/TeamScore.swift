import Foundation

final class TeamScore {
    var redTeamScore: Int
    var blueTeamScore: Int
    
    init(redTeamScore: Int, blueTeamScore: Int) {
        self.redTeamScore = redTeamScore
        self.blueTeamScore = blueTeamScore
    }
    
    func addWord (to team: Team) -> Team? {
        switch team {
            case .blueTeam: blueTeamScore = blueTeamScore - 1
            case .redTeam: redTeamScore = redTeamScore - 1
        }
        if defineLider() {
            return team
        }
        return nil
    }
    
    private func defineLider () -> Bool {
        return redTeamScore == 0 || blueTeamScore == 0
    }
}
