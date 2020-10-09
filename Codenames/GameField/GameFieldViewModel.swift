import UIKit

final class GameFieldViewModel: GameFieldViewModelProtocol {

    var buttonTapped: ((Int) -> ())?
    var setWords: (([WordObject]) -> ())?
    var showLeader: ((String) ->())?
    private let gameManager: GameManager
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
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        gameManager.subscribeToUpdate({ [weak self] game in
            if self?.setWords != nil {
                self?.setWords! (game.words)
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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

