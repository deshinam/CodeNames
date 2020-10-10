import Foundation

final class SettingsViewModel {
    // MARK: — Private Properties
    private var gameManager: GameManager
    
    // MARK: — Public Properties
    var setTeamScores: ((Int, Int) -> ())?
    var dismissAction: (() -> ())?
 
    // MARK: — Initializers
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
