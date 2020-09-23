import UIKit
import SnapKit

final class GameFieldViewController: UIViewController {
    
    private var teamsScore: TeamScore?
    private let gameView = GameView()
    private var userType: UserType?
    private var viewModel: GameFieldViewModelProtocol?
    
    init(userType: UserType,viewModel: GameFieldViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.userType = userType
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.setWords = {[weak self] words in
            DispatchQueue.main.async {
                self?.setupViewController(words: words)
            }
        }
        
        viewModel?.buttonTapped = {[weak self] (color, id) in
               self?.gameView.wordButtons[id].backgroundColor = color
        }
        gameView.buttonTapped = viewModel?.buttonTapped
        viewModel?.showLeader = {[weak self] messageText in
            let alert = UIAlertController(title: "Congratulations!", message: messageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    private func setupViewController(words: [WordObject]) {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let settingsView = SettingsView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsView)
        print(view.frame)
        print(settingsView.frame)
        settingsView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin)
            make.height.equalTo(100)
            make.trailing.equalTo(view.snp.trailing).inset(10)
            make.leading.equalTo(view.snp.leading).inset(10)
        }
        settingsView.setupView()
       
        gameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameView)
        gameView.snp.makeConstraints { make in
            make.bottom.equalTo(settingsView.snp.top).inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            make.trailing.equalTo(view.snp.trailing).inset(10)
            make.leading.equalTo(view.snp.leading).inset(10)
        }
        guard userType != nil else {
            return
        }
        gameView.setupView(words: words, userType: userType!)
    }
}


