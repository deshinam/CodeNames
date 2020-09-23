import Foundation

class SettingsViewModel {
    
    var setTeamScores: ((Int, Int) -> ())?
    private var teamScores = TeamScore(redTeamScore: 10, blueTeamScore: 9)
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(addWord(_:)), name: NSNotification.Name(rawValue: "ButtonTapped"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addWord(_ notification: Notification) {
        if notification.userInfo != nil {
            if let leader = teamScores.addWord(to: notification.userInfo!["Team"] as! Team) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Leader"), object: nil, userInfo: ["leader": leader.toString()+"is a winner"])
            }
            updateScores()
        }
    }
    
    func updateScores() {
        if setTeamScores != nil {
            setTeamScores!(teamScores.redTeamScore, teamScores.blueTeamScore)
        }
    }
}

