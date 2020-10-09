import Foundation

class SettingsViewModel {
    
    var setTeamScores: ((Int, Int) -> ())?
    var dismissAction: (() -> ())?
    private var gameManager: GameManager
 
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        gameManager.subscribeToUpdate({[weak self] game in
            let teamScores = game.teamScore
            if self?.setTeamScores != nil {
                self?.setTeamScores!(teamScores.redTeamScore, teamScores.blueTeamScore)
            }
        })
    }
}
