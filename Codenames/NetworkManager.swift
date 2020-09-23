import Foundation
import Firebase

class NetworkManager {
    private var DB = Firestore.firestore()
    private var reference: DatabaseReference?
    
    init() {
        reference = Database.database().reference().child("games")

    }
    
    func generateWords( closure: @escaping ([String]) -> ()) {
        let urlString = "https://random-word-api.herokuapp.com/word?number=30"
        var words: [String]?
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {  (data, response, error) in
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String]
                        words = json
                        closure(words ?? [])
                    } catch let error as NSError {
                        closure(["word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3","word 1", "word 2","word 3"])
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    func generateCodeName(closure: @escaping (String) -> ()) {
        let urlString = "https://random-word-api.herokuapp.com/word?number=1"
        var word: String?
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {  (data, response, error) in
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String]
                        word = json?[0]
                        closure(word ?? "[]")
                    } catch let error as NSError {
                        closure("word 1")
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    func save(game: Game) {
        reference?.setValue(game.toDictionary())
    }

    func getGame(codeName: String, callback: @escaping (Any?)->()) {
        reference = reference?.child(codeName)
        reference?.observe(DataEventType.value, with: {snapshot in
            callback(snapshot.value)
            print("some changes in FB \(snapshot.value)")
        })

    }
    
}
