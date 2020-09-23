
import Foundation

class GameFieldBuilder {
    func setup(userType: UserType, game: Game) -> GameFieldViewController {
        
        let viewModel = GameFieldViewModel(game: game)
        let viewController = GameFieldViewController(userType: userType, viewModel: viewModel)
        
        return viewController
    }
}
