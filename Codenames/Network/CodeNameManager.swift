
import Foundation
import Firebase

final class CodeNameManager {
    // MARK: — Private Properties
    private var reference: DatabaseReference?
    private let timeLimit: Double = 60 * 60 * 6
    
    // MARK: — Initializers
    init() {
        reference = Database.database().reference()
    }
    
    // MARK: — Private Methods
    private func getIndex(closure: @escaping (Int) -> ()) {
        reference?.child("dictionary").child("free").child("count").observeSingleEvent(of: DataEventType.value, with: { snapshot in
            let countOfWords = snapshot.value as? Int
            if countOfWords != nil  {
                let index = countOfWords! - 1
                closure(index)
            }
        })
    }
    
    private func getWord(index: Int, closure: @escaping (String)->()) {
        reference?.child("dictionary").child("free").child("\(index)").child("word").observeSingleEvent(of: DataEventType.value, with: {snapshot in
            let word = snapshot.value as? String
            closure(word ?? String().getRandomWord())
        })
    }
    
    private func getAllBusyWords(closure: @escaping ([String:Double])->() ) {
        reference?.child("dictionary").child("busy").observeSingleEvent(of: DataEventType.value, with: {snapshot in
            let busyWords = snapshot.value as? [String:Double]
            closure(busyWords ?? [:])
        })
    }
    
    private func filterFreeWords(busyWords: [String:Double]) -> [String] {
        let freeWords = busyWords.map { (word, date) in Date().timeIntervalSince1970 - date >= timeLimit ? word : nil}.filter{$0 != nil}
        return freeWords as! [String]
    }
    
    private func transferBusyWordsToFreeWords(index: Int, newFreeWords: [String]) -> Int {
        for (ind, freeWord) in newFreeWords.enumerated() {
            reference?.child("dictionary").child("free").child("\(index+1+ind)").child("word").setValue(freeWord)
            reference?.child("dictionary").child("busy").child(freeWord).removeValue()
        }
        let countOfFreeWords = index + 1 + newFreeWords.count
        reference?.child("dictionary").child("free").child("count").setValue(countOfFreeWords)
        return countOfFreeWords - 1
    }
    
    private func makeWordBusy(word: String, index: Int) {
        reference?.child("dictionary").child("busy").child(word).setValue(Date().timeIntervalSince1970 as Double)
        reference?.child("dictionary").child("free").child(String(index)).removeValue()
        if index >= 0 {
            reference?.child("dictionary").child("free").child("count").setValue(index)
        }
    }
    
    // MARK: — Public Methods
    func getCodeName(closure: @escaping (String) -> ()) {
        let queue = DispatchQueue(label: "com.codename.wordqueue")
        queue.sync {
            getIndex(closure: {[weak self] index in
                if index >= 0 {
                    self?.getWord(index: index, closure: {[weak self] word in
                        self?.makeWordBusy(word: word, index: index)
                        closure(word)
                    })
                } else {
                    self?.getAllBusyWords(closure: {[weak self] busyWords in
                        if let freeWords = self?.filterFreeWords(busyWords: busyWords) {
                            guard let newIndex = self?.transferBusyWordsToFreeWords(index: index, newFreeWords: freeWords) else {return}
                            self?.getWord(index: newIndex, closure: {[weak self] word in
                                self?.makeWordBusy(word: word, index: newIndex)
                                closure(word)
                            })
                        }
                    })
                }
            })
        }
    }
    
    func checkGame(codeName: String, closure: @escaping (Bool)->()) {
        reference?.child("dictionary").child("busy").child(codeName).observeSingleEvent(of: DataEventType.value, with: {[weak self] snapshot in
            if (snapshot.value == nil) || (Date().timeIntervalSince1970 - (snapshot.value as? Double ?? 0) >= self?.timeLimit ?? 0)  {
                closure(false)
            } else {
                closure(true)
            }
        })
    }
    
    func updateLastEditDate(codeName: String) {
        reference?.child("dictionary").child("busy").child(codeName).setValue(Date().timeIntervalSince1970)
    }
}
