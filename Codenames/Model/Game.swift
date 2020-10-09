import Foundation


typealias GameStatus = (isFinished: Bool, winner: Team?)
class Game {
    var codeName: String
    var words: [WordObject]
    var lastUpdate: Double
    var teamScore: TeamScore {
        let teamScore = TeamScore(redTeamScore: 0, blueTeamScore: 0)
        words.forEach { word in
            if word.isOpened == false {
                if word.team == .redTeam {
                    teamScore.redTeamScore += 1
                } else if word.team == .blueTeam {
                    teamScore.blueTeamScore += 1
                }
            }
        }
        return teamScore
    }
    
    var isGameOver: GameStatus {
        if teamScore.redTeamScore == 0 && teamScore.blueTeamScore == 0 {
            return GameStatus(true, nil)
        } else if teamScore.redTeamScore == 0 || teamScore.blueTeamScore == 0 {
            return GameStatus(true, (teamScore.redTeamScore == 0) ? .redTeam : .blueTeam)
        }
        return GameStatus(false, nil)
    }
    
    init() {
        codeName = ""
        words = []
        lastUpdate = 0
    }
    
    init(codeName: String, lastUpdate: Double, words: [WordObject]) {
        self.codeName = codeName
        self.words = words
        self.lastUpdate = lastUpdate
    }
    
    convenience init(codeName: String, lastUpdate: Double, words: [[String:String]]) {
        self.init()
        self.codeName = codeName
        self.lastUpdate = lastUpdate
        words.forEach {[weak self] word in
            self?.words.append(WordObject(word: word))
        }
    }
    
    func toDictionary() -> [String:Any] {
        var wordsToDictionary: [[String:String]] = []
        words.forEach{ word in
            wordsToDictionary.append(word.toDictionary())
        }
        var gameToDictionary: [String:Any] = [:]
        gameToDictionary["words"] = wordsToDictionary
        gameToDictionary["lastUpdate"] = lastUpdate
        return [codeName:gameToDictionary]
    }
    
    func toDictionaryWithOpenCells() -> [String:Any] {
        var wordsToDictionary: [[String:String]] = []
        words.forEach{ word in
            var openedWord = word.toDictionary()
            openedWord["isOpened"] = "true"
            wordsToDictionary.append(openedWord)
        }
        
        var gameToDictionary: [String:Any] = [:]
        gameToDictionary["words"] = wordsToDictionary
        gameToDictionary["lastUpdate"] = lastUpdate
        return [codeName:gameToDictionary]
    }
    

}
