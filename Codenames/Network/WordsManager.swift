import Foundation
import Firebase

class WordsManager {
    private var reference: DatabaseReference?
    private let countOfWordsForGame = 30
    
    init() {
        reference = Database.database().reference()
    }
    
    func generateWords(closure: @escaping ([String])->()) {
        let countOfWords = countOfWordsForGame + 10
        getRandomWordsDictionary(countOfWords: countOfWords, closure: {[weak self] (words, wordsForChangingId) in
            let wordsForGame = self?.chooseWordsForGame(dictionary: words)
            //update ids
            self?.changeWordsIdForRandom(wordsForChangingId: wordsForChangingId)
            closure(wordsForGame ?? [])
            })
    }
    
    private func getRandomWordsDictionary(countOfWords: Int, closure: @escaping ([Int:String],[Int])->()) {
        reference?.child("gameWords").queryOrdered(byChild: "id").queryLimited(toFirst: UInt(countOfWords)).observeSingleEvent(of: DataEventType.value, with: {snapshot in
            let words = snapshot.value as? [String:Any]
            var wordsDictionary: [Int:String] = [:]
            var wordsForChangingId: [Int] = []
            var index = 0
            
            if let wordsIds = words?.keys {
                wordsForChangingId = wordsIds.map {(Int ($0) ?? 0)}
            }
            
            words?.forEach { wordData in
                if let newWord = (wordData.value as? [String:Any])?["word"] as? String {
                    wordsDictionary[index] = newWord
                    index += 1
                }
            }
                closure(wordsDictionary, wordsForChangingId)
            })
    }
    
    private func chooseWordsForGame(dictionary: [Int:String]) -> [String] {
        var gameWords: [String] = []
        var indexesForGame = Set<Int>()
        var index = 0
        
        repeat {
            index = Int.random(in: 0...dictionary.count-1)
            if !indexesForGame.contains(index) {
                indexesForGame.insert(index)
            }
        } while indexesForGame.count < countOfWordsForGame
        
        indexesForGame.forEach { id in
            if let word = dictionary[id] {
                gameWords.append(word)
            } else {
                print("\(id) \(dictionary[id])")
            }
        }
     
        return gameWords
    }
    
    func createWords() {
        for i in 0...100 {
            reference?.child("gameWords").child("\(i)").child("id").setValue("\(i)")
            reference?.child("gameWords").child("\(i)").child("word").setValue("word \(i)")
        }
    }
    
    private func changeWordsIdForRandom(wordsForChangingId: [Int]) {
        wordsForChangingId.forEach { id in
            reference?.child("gameWords").child("\(id)").child("id").setValue(Int.random(in: 0...Int.max-1))
        }
    }
}
