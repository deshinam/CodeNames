import Foundation

final class StartScreenViewModel {
    // MARK: — Private Properties
    private let gameManager = GameManagerBuilder().build()
    private var game: Game?
    
    // MARK: — Public Properties
    var showGameField: ((GameFieldViewController)->())?
    var setCodeName: ((String) -> ())?
}

extension StartScreenViewModel: StartScreenViewModelProtocol {
    // MARK: — Public Properties
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
    
    // MARK: — Public Methods
    func generateGame() {
        gameManager.generateGame(callback: { [weak self] game in
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
