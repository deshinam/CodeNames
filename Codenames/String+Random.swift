import Foundation

extension String {
    func getRandomWord() -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyz")
        var word = ""
        let countOfLetters = Int.random(in: 6...11)
        for _ in 0...countOfLetters {
            let symbol = chars[Int.random(in: 0...chars.count-1)]
            word = word + String(symbol)
        }
        return word
    }
}
