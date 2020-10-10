import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseApp.configure()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = NavigationViewController()
        let startScreen = StartScreenViewController()
        navigationController.viewControllers = [startScreen]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


