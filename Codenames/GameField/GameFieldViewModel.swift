import UIKit

final class GameFieldViewModel {
    // MARK: — Private Properties
    private let gameManager: GameManager
    
    // MARK: — Public Properties
    var buttonTapped: ((Int) -> ())?
    var setWords: (([WordObject]) -> ())?
    var showLeader: ((String) ->())?
    
    // MARK: — Initializers
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        gameManager.subscribeToUpdate({ [weak self] game in
            if self?.setWords != nil {
                self?.setWords! (game.words)
            }
        })
    }
    
    // MARK: — Deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension GameFieldViewModel: GameFieldViewModelProtocol {
    // MARK: — Public Properties
    var finishGame: ((Team?)->())? {
        get {
            return nil
        }
        set {
            gameManager.finishGame = newValue
        }
    }
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
    func cellIsOpened(id: Int) {
        gameManager.cellIsOpened(id: id)
    }
    
    func getGameManager() -> GameManager {
        return gameManager
    }
    
    func getWords() {
        if setWords != nil {
            setWords!(gameManager.getWords())
        }
    }
}
