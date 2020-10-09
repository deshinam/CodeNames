import Foundation

class StartScreenViewModel: StartScreenViewModelProtocol {    
    private let gameManager = GameManagerBuilder().build()
    private var game: Game?
    var showGameField: ((GameFieldViewController)->())?
    var setCodeName: ((String) -> ())?
    var gameIsnotValid: (()->())? {
        get {
            return nil
        }
        set {
            if newValue != nil {
                gameManager.subscribeToError(newValue!)
            }
        }
    }
    
    func generateGame() {
        gameManager.generateGame(callback: { [weak self] game in
            print("Game was generated: \(game?.codeName)")
            self?.setCodeName?(game?.codeName ?? "error")
            self?.game = game
        })
    }
    
    func startGame(codeName: String, userType: UserType) {
        gameManager.updateCodeName(newCodeName: codeName)
        let gameField = GameFieldBuilder().setup(userType: userType, gameManager: (gameManager))
        gameManager.connectWithGame(closure: { [weak self] gameIsCorrect in
            if gameIsCorrect && self?.gameManager != nil {
                if self?.showGameField != nil {
                    self?.showGameField!(gameField)
                }
            }
        })
    }
}
