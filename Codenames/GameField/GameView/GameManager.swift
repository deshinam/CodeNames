import UIKit

final class GameManager {
    private var colors: [CellsSettings] = [CellsSettings(color: .systemRed, count: 10),
                                           CellsSettings(color: .systemBlue, count: 9),
                                           CellsSettings(color: .black, count: 1),
                                           CellsSettings(color: .systemGray6, count: 10)]
    private var countOfCells = 3
    private var wordObjects = [WordObject]()
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func generateGame (callback: @escaping (Game?)->()) {
        var keyword = "l"
        DispatchQueue.global(qos: .background).sync {
            networkManager.generateCodeName(closure: { codename in
                keyword = codename
            })
        }
        DispatchQueue.global(qos: .background).sync {
            
            networkManager.generateWords( closure: {[weak self] data in
                repeat {
                    let word = data.randomElement()
                    let i = Int.random(in: 0..<(self?.colors.count)!)
                    let color = self?.colors[i].color
                    if self?.colors[i].count == 0 {
                        self?.colors.remove(at: i)
                    }
                    var team: Team? = nil
                    if color == .systemRed {
                        team = .redTeam
                    } else if color == .systemBlue {
                        team = .blueTeam
                    }
                    self?.wordObjects.append(WordObject(id: self?.wordObjects.count ?? 30, word: word!, color: color ?? .white, team: team, isOpened: false))
                } while self?.wordObjects.count ?? 0 < data.count
                
                guard self?.wordObjects != nil else {
                    return
                }
                let game = Game(codeName: keyword, words: self?.wordObjects ?? [])
                self?.networkManager.save(game: game)
                callback(game)
                
            })
        }
    }
    
    func getGame(codeName: String, callback: @escaping (Game?)->()) {
        networkManager.getGame(codeName: codeName,callback: {data in
            print("for check \(data)")
            let jsonStr = "\(data!)"
            guard let jsonData: Data = jsonStr.data(using: .utf8) else {
                    return
                }
                do {
                    let words = try JSONDecoder().decode([WordObject].self, from: jsonData)
                    let game = Game(codeName: codeName, words: words)
                    print(game)
                } catch {
                    print(error)
                }
            
        
        })
    
}
}
