import UIKit
import SnapKit

final class StartScreenViewController: UIViewController {
    
    private var startCaptainButton: UIButton?
    private var startPlayersButton: UIButton?
    private var generateCodeButton: UIButton?
    private var viewModel: StartScreenViewModelProtocol = StartScreenViewModel()
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewController()
        
        viewModel.setCodeName = { [weak self] codeName in
            DispatchQueue.main.async {
                self?.codeTextField.text = codeName
            }
        }
    }
    
    private var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private func setupViewController() {
        setupElements()
        setUpConstraints()
    }
    
    private func setupElements() {
        view.addSubview(codeTextField)
        startCaptainButton = StartButton(frame: .zero)
        startPlayersButton = StartButton(frame: .zero)
        generateCodeButton = StartButton(frame: .zero)
        generateCodeButton!.addTarget(self, action: #selector(generateGame(_ :)), for: .touchUpInside)
        
        startCaptainButton?.tag = 0
        startCaptainButton!.addTarget(self, action: #selector(startGame(_ :)), for: .touchUpInside)
        startPlayersButton?.tag = 1
        startPlayersButton!.addTarget(self, action: #selector(startGame(_ :)), for: .touchUpInside)
        
        startCaptainButton!.setTitle("Start as captain", for: .normal)
        startPlayersButton!.setTitle("Start as player", for: .normal)
        generateCodeButton!.backgroundColor = .darkGray
        generateCodeButton!.layer.borderColor = UIColor.darkGray.cgColor
        generateCodeButton!.setTitle("Generate code", for: .normal)
        
        view.addSubview(startCaptainButton!)
        view.addSubview(startPlayersButton!)
        view.addSubview(generateCodeButton!)
    }
    
    private func setUpConstraints() {
        codeTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 40))
            make.top.equalTo(view.snp.top).inset(100)
        }
        
        generateCodeButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 40))
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
        }
        
        startCaptainButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 40))
            make.bottom.equalTo(view.snp.bottom).inset(70)
        }
        
        startPlayersButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 40))
            make.bottom.equalTo(startCaptainButton!.snp.top).offset(-10)
        }
    }
    
    @objc private func startGame(_ sender: UIButton?) {
        if codeTextField.text != "" && codeTextField.text != nil {
            switch sender?.tag {
            case 0:
                if let gameFieldViewController = viewModel.createGameField(codeName: codeTextField.text!, userType: .captain) {
                    self.show(gameFieldViewController, sender: nil)
               }
            case 1:
                if let gameFieldViewController = viewModel.createGameField(codeName: codeTextField.text!, userType: .player) {
                    self.show(gameFieldViewController, sender: nil)
                }
            default:
                break
            }
        }

    }
    
    @objc private func generateGame(_ sender: UIButton?) {
        viewModel.generateGame()
    }
    
}

