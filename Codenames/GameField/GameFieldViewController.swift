import UIKit
import SnapKit

final class GameFieldViewController: UIViewController {
    
    private var teamsScore: TeamScore?
    private var gameView: GameView?
    private var userType: UserType
    private var viewModel: GameFieldViewModelProtocol
    private var settingsView: SettingsView
    
    init(userType: UserType,viewModel: GameFieldViewModelProtocol) {
        self.userType = userType
        self.viewModel = viewModel
        let settingsBuilder = SettingsBuilder()
        settingsView = settingsBuilder.build(gameManager: viewModel.getGameManager())
        super.init(nibName: nil, bundle: nil)
        settingsBuilder.dismissAction(closure: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        } )
        self.viewModel.finishGame = {[weak self] team in
            var messageText = "Game is over"
            if team != nil {
                messageText = "\(team!.toString()) is a winner"
            }
            let alert = UIAlertController(title: "Congratulations!", message: messageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
        
        self.viewModel.gameIsnotValid = {[weak self] in
            let alert = UIAlertController(title: "Error", message: "Game is not exist!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.setWords = {[weak self] words in
            DispatchQueue.main.async {
                if self?.gameView == nil {
                    self?.gameView = GameView()
                    self?.setupViewController()
                    self?.gameView?.setupView(words: words, userType: self?.userType ?? .player)
                    self?.gameView?.buttonTapped = self?.viewModel.buttonTapped
                } else {
                    self?.gameView?.updateButtonColors(words: words)
                }
            }
        }
        viewModel.buttonTapped = {[weak self] (id) in
            self?.viewModel.cellIsOpened(id: id)
        }
        viewModel.getWords()
    }
    
    private func setupViewController() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsView)
        print(view.frame)
        print(settingsView.frame)
        settingsView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin)
            make.height.equalTo(100)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailingMargin)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leadingMargin)
        }
        settingsView.setupView()
        
        gameView?.translatesAutoresizingMaskIntoConstraints = false
        if gameView != nil {
            view.addSubview(gameView!)
        }
        
        gameView?.snp.makeConstraints { make in
            make.bottom.equalTo(settingsView.snp.top).inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailingMargin)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leadingMargin)
        }
        
    }
    
}


