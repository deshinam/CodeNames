import UIKit

final class GameFieldViewModel: GameFieldViewModelProtocol {
    
    var buttonTapped: ((UIColor, Int) -> ())?
    var setWords: (([WordObject]) -> ())?
    var wordsForGame: [WordObject]!
    var showLeader: ((String) ->())?
    private let gameManager = GameManagerBuilder().build()
    private var currentGame: Game
    
    init(game: Game) {
        currentGame = game
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLeader(_:)), name: NSNotification.Name(rawValue: "Leader"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func wordTapped(buttonId: Int) {
        buttonTapped!(wordsForGame[buttonId].color, buttonId)
        if wordsForGame[buttonId].color == .black {
            
        }
    }
    
    @objc func showLeader(_ notification: Notification) {
        showLeader!(notification.userInfo!["leader"] as! String)
    }
}

