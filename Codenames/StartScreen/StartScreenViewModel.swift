import Foundation

class StartScreenViewModel: StartScreenViewModelProtocol {
    
    private let gameManager = GameManagerBuilder().build()
    private var game: Game?
    var setCodeName: ((String) -> ())?
    
    func generateGame() {
        gameManager.generateGame(callback: { [weak self] game in
            print("Game was generated: \(game?.codeName)")
            self?.setCodeName?(game?.codeName ?? "error")
            self?.game = game
        })
    }
    
    func createGameField(codeName: String, userType: UserType) -> GameFieldViewController? {

//        if codeName == game?.codeName {
//            return GameFieldBuilder().setup(userType: userType, game: game!)
//        }
        gameManager.getGame(codeName: codeName, callback: {_ in})
//        if let newGame = gameManager.getGame(codeName: codeName, callback: <#T##(Game?) -> ()#>) {
//            return GameFieldBuilder().setup(userType: userType, game: newGame)
//        } else {
//            return nil
//        }
        return nil
    }


}
