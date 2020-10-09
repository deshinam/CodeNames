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
        
        self.viewModel.gameIsnotValid = {[weak self] in
            let alert = UIAlertController(title: "Error", message: "Game is not exist!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
        }
        
        self.viewModel.showGameField =  {[weak self] gameField in
            self?.show(gameField, sender: nil)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private var codeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        return textField
    }()
    
    private func setupViewController() {
        setupElements()
        setUpConstraints()
    }
    
    private func setupElements() {
        view.addSubview(codeTextField)
        view.addSubview(codeTextLabel)
        
        codeTextLabel.text = "Enter the code for the created game or create a new game"
        
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
        codeTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 300, height: 60))
            make.top.equalTo(view.snp.top).inset(60)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 300, height: 40))
            make.top.equalTo(codeTextLabel.snp.bottom).offset(10)
        }
        
        generateCodeButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 300, height: 40))
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
        }
        
        startCaptainButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 250, height: 40))
            make.bottom.equalTo(view.snp.bottom).inset(40)
        }
        
        startPlayersButton!.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 250, height: 40))
            make.bottom.equalTo(startCaptainButton!.snp.top).offset(-10)
        }
    }
    
    @objc private func startGame(_ sender: UIButton?) {
        if codeTextField.text != "" && codeTextField.text != nil {
            switch sender?.tag {
            case 0:
                viewModel.startGame(codeName: codeTextField.text!, userType: .captain)
            case 1:
                viewModel.startGame(codeName: codeTextField.text!, userType: .player)
            default:
                break
            }
        }

    }
    
    @objc private func generateGame(_ sender: UIButton?) {
        view.endEditing(true)
        viewModel.generateGame()
    }
    
}

