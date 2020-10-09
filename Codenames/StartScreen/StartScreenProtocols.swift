
import Foundation

protocol StartScreenViewModelProtocol {
    var setCodeName: ((String) -> ())? {get set}
    var gameIsnotValid: (()->())? {get set}
    var showGameField: ((GameFieldViewController)->())? {get set}
    func generateGame()
    func startGame(codeName: String, userType: UserType)
}
