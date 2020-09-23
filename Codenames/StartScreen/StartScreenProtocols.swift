
import Foundation

protocol StartScreenViewModelProtocol {
    var setCodeName: ((String) -> ())? {get set}
    func generateGame()
    func createGameField(codeName: String, userType: UserType) -> GameFieldViewController?
}
