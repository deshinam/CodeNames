import UIKit

final class GameManager {
    
    private var countOfCells = 3
    private var networkManager: NetworkManager
    private var codeNameManager: CodeNameManager
    private var wordsManager: WordsManager
    private var codeName = "l"
    private var game: Game?
    private var updateGame: [((Game)->())]?
    var finishGame: ((Team?)->())?
    private var gameIsnotValid: [()->()]
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        codeNameManager = CodeNameManager()
        wordsManager = WordsManager()
        updateGame = []
        gameIsnotValid = []
        networkManager.updateGame = {[weak self] data in
            guard let gameCode = self?.codeName else {return}
            self?.game = Game(codeName: gameCode, lastUpdate: data["lastUpdate"] as? Double ?? 0, words: data["words"] as? [[String:String]] ?? [])
            if self?.game != nil {
                self?.updateGame?.forEach { updateAction in
                    if self?.game != nil {
                        updateAction((self?.game)!)
                        if (self?.game?.isGameOver.isFinished)! && self?.finishGame != nil {
                            self?.finishGame!(self?.game?.isGameOver.winner)
                        }
                    }
                }
            }
        }
    }
    
    func generateGame (callback: @escaping (Game?)->()) {
        DispatchQueue.global(qos: .background).sync {
            codeNameManager.getCodeName(closure: { [weak self] data in
                self?.codeName = data
                print("new code Name: \(self?.codeName)")
                self?.wordsManager.generateWords(closure: {data in
                    guard let game = self?.generateWords(data: data) else {return}
                    let gameData = game.toDictionary()[game.codeName] as? [String:Any]
                    self?.networkManager.save(codeName: game.codeName, gameData: gameData ?? [:])
                    callback(game)
                    
                })
            })
        }
    }
    
    func generateWords(data: [String])-> Game {
        var wordObjects = [WordObject]()
        var colors: [CellsSettings] = [CellsSettings(color: Constants.redColor, count: 10),
                                       CellsSettings(color: Constants.blueColor, count: 9),
                                               CellsSettings(color: .black, count: 1),
                                               CellsSettings(color: Constants.grayColor, count: 10)]
        print(wordObjects)
        var wordIndex = 0
        repeat {
            let word = data[wordIndex]
            let i = Int.random(in: 0..<(colors.count))
            let color = colors[i].color
            colors[i].count -= 1
            if colors[i].count == 0 {
                colors.remove(at: i)
            }
            var team: Team? = nil
            if color == Constants.redColor {
                team = .redTeam
            } else if color == Constants.blueColor {
                team = .blueTeam
            }
            wordObjects.append(WordObject(id: wordObjects.count, word: word, color: color, team: team, isOpened: false))
            wordIndex += 1
        } while wordObjects.count < 30
        print(wordObjects.count)
        let game = Game(codeName: codeName, lastUpdate: Date().timeIntervalSince1970 as Double, words: wordObjects)
        return game
    }
    
    func connectWithGame(closure: @escaping (Bool)->()) {
        codeNameManager.checkGame(codeName: codeName, closure: { [weak self] gameIsCorrect in
            if gameIsCorrect && self?.codeName != nil {
                self?.networkManager.connectWithGame(codeName: (self?.codeName)!)
                closure(true)
            } else {
                self?.notifySubscribersAboutError()
                closure(false)
            }
        })
    }
    
    func cellIsOpened(id: Int) {
        if game?.words[id].color == .black {
            let gameData = game?.toDictionaryWithOpenCells()[codeName] as? [String:Any]
            networkManager.openAllCells(codeName:codeName, game: gameData ?? [:])
        } else {
            networkManager.cellIsOpened(id: id, codeName: codeName)
        }
    }
    
    func subscribeToUpdate(_ closure: @escaping (Game)->()) {
        updateGame?.append(closure)
    }
    
    func subscribeToError(_ closure: @escaping ()->()) {
        gameIsnotValid.append(closure)
    }
    
    func updateCodeName(newCodeName: String) {
        codeName = newCodeName
    }
    
    func notifySubscribersAboutError() {
        gameIsnotValid.forEach { action in
            action()
        }
    }
    
    func getWords() -> [WordObject] {
        return game?.words ?? []
    }
    
}
