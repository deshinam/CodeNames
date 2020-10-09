import UIKit

protocol GameFieldViewModelProtocol {
    var setWords: (([WordObject]) -> ())? {get set}
    var buttonTapped: ((Int) -> ())? {get set}
    var showLeader: ((String) ->())? {get set}
    var finishGame: ((Team?)->())? {get set}
    var gameIsnotValid: (()->())? {get set}
    func cellIsOpened(id: Int)
    func getGameManager() -> GameManager
    func getWords() 
}
