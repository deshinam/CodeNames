
import UIKit
import SnapKit

final class SettingsView: UIView {
    // MARK: — Private Properties
    private var settingdViewModel = SettingsViewModel()
    
    private var redTeamScore: UILabel = {
        let redTeamScore = UILabel()
        redTeamScore.textAlignment = .center
        redTeamScore.textColor = .white
        redTeamScore.backgroundColor = .systemRed
        redTeamScore.translatesAutoresizingMaskIntoConstraints = false
        return redTeamScore
    }()
    
    private var blueTeamScore: UILabel = {
        let blueTeamScore = UILabel()
        blueTeamScore.textAlignment = .center
        blueTeamScore.textColor = .white
        blueTeamScore.backgroundColor = .systemBlue
        blueTeamScore.translatesAutoresizingMaskIntoConstraints = false
        return blueTeamScore
    }()
    
    // MARK: — Initializers
    init () {
        super.init(frame: .zero)
        settingdViewModel.setTeamScores = {[weak self] (red, blue) in
            self?.redTeamScore.text = String (red)
            self?.blueTeamScore.text = String (blue)
        }
        settingdViewModel.updateScores()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

