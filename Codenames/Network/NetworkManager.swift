import Foundation
import Firebase

class NetworkManager {
    private var reference: DatabaseReference?
    var updateGame: (([String:Any])->())?
    
    init() {
        reference = Database.database().reference()
            //.child("games")
    }
    
    func generateWords( closure: @escaping ([String]) -> ()) {
        let urlString = "https://random-word-api.herokuapp.com/word?number=30"
        var words: [String]?
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self]  (data, response, error) in
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String]
                        words = json
                      //  self.wordsManager.createWords()
                    
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

    
    func save(codeName: String, gameData: [String:Any]) {
        reference?.child("games").child(codeName).setValue(gameData)
    }

    func connectWithGame(codeName: String) {
        reference?.child("games").child(codeName).observe(DataEventType.value, with: { [weak self] snapshot in
            let snpToDictionary = snapshot.value as? [String:Any]
            guard let updateAction = self?.updateGame else {return}
            updateAction(snpToDictionary ?? [:])
            print(snapshot.value)
        })
    }
    
    func cellIsOpened(id: Int, codeName: String) {
        reference?.child("games").child(codeName).child("words").child("\(id)").child("isOpened").setValue("true")
        reference?.child("games").child(codeName).child("lastUpdate").setValue(Date().timeIntervalSince1970 as Double)
    }
    
    func openAllCells(codeName: String, game: [String:Any]) {
        reference?.child("games").child(codeName).setValue(game)
    }
    
    func deleteGame(codeName: String) {
        reference?.child("games").child(codeName).removeValue()
    }
}
