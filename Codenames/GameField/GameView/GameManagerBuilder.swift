import Foundation
import Swinject

final class GameManagerBuilder {
    func build() -> GameManager {
        let container = Container()
        container.register(NetworkManager.self) { _ in
            NetworkManager()
        }
        container.register(GameManager.self) { c in
            GameManager(networkManager: c.resolve(NetworkManager.self)!)
        }
        return container.resolve(GameManager.self)!
    }
}
