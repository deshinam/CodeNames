import Foundation

struct Game: Codable {
    var codeName: String
    var words: [WordObject]
    
    func toDictionary() -> [String:[[String:String]]] {
        var wordsToDictionary: [[String:String]] = []
        words.forEach{ word in
            wordsToDictionary.append(word.toDictionary())
        }
        return [codeName:wordsToDictionary]
    }
}
