
import UIKit
import SnapKit

final class SettingsView: UIView {
    // MARK: — Private Properties
    private var settingsViewModel: SettingsViewModel
    private var redTeamScore: UILabel = {
        let redTeamScore = UILabel()
        redTeamScore.textAlignment = .center
        redTeamScore.textColor = .white
        redTeamScore.backgroundColor = Constants.redColor
        redTeamScore.translatesAutoresizingMaskIntoConstraints = false
        return redTeamScore
    }()
    private var blueTeamScore: UILabel = {
        let blueTeamScore = UILabel()
        blueTeamScore.textAlignment = .center
        blueTeamScore.textColor = .white
        blueTeamScore.backgroundColor = Constants.blueColor
        blueTeamScore.translatesAutoresizingMaskIntoConstraints = false
        return blueTeamScore
    }()
    private var backButton: UIButton = {
        let backButton = UIButton()
        backButton.layer.borderColor = UIColor.systemGray5.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 10
        backButton.setTitleColor(.white, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    // MARK: — Initializers
    init (settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        super.init(frame: .zero)
        settingsViewModel.setTeamScores = {[weak self] (red, blue) in
            self?.redTeamScore.text = String (red)
            self?.blueTeamScore.text = String (blue)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: — Private Methods
    @objc private func backButtonTapped(sender: UIButton) {
        guard settingsViewModel.dismissAction != nil else { return }
        settingsViewModel.dismissAction!()
    }
    
    // MARK: — Public Methods
    func setupView() {
        self.addSubview(redTeamScore)
        redTeamScore.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(-10)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
        }
        
        self.addSubview(blueTeamScore)
        blueTeamScore.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(-10)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
        }
        
        self.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
            make.width.equalTo(self.snp.width).multipliedBy(0.15)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:)), for: .touchUpInside)
    }
}
