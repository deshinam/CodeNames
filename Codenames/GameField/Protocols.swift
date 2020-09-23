import UIKit

protocol GameFieldViewModelProtocol {
    var setWords: (([WordObject]) -> ())? {get set}
    var buttonTapped: ((UIColor, Int) -> ())? {get set}
    var showLeader: ((String) ->())? {get set}
}
