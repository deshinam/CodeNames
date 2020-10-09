
import Foundation

class GameFieldBuilder {
    func setup(userType: UserType, gameManager: GameManager) -> GameFieldViewController {
        let viewModel = GameFieldViewModel(gameManager: gameManager)
        let viewController = GameFieldViewController(userType: userType, viewModel: viewModel)
        
        return viewController
    }
}
