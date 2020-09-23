import UIKit

struct WordObject: Decodable, Encodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, word, color, isOpened
    }
    
    var id: Int
    var word: String
    var color: UIColor
    var team: Team?
    var isOpened: Bool
    
    init(id: Int, word: String, color: UIColor, team: Team?, isOpened: Bool) {
        self.id = id
        self.word = word
        self.color = color
        self.team = team
        self.isOpened = isOpened
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        id = try container.decode(Int.self, forKey: .id)
        word = try container.decode(String.self, forKey: .word)
        isOpened = try container.decode(Bool.self, forKey: .isOpened)
        
        let colorString = try container.decode(String.self, forKey: .color)
        if colorString == "red" {
            color = .red
        } else if colorString == "blue" {
            color = .blue
        } else {
            color = .white
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(word, forKey: .word)
        try container.encode(isOpened, forKey: .isOpened)
        try container.encode("red", forKey: .color)
    }
    
    func toDictionary() -> [String:String] {
        var dictionary:[String: String] = [:]
        dictionary["id"] = "\(id)"
        dictionary["word"] = "\(word)"
        dictionary["color"] = "\(colorToString())"
        dictionary["isOpened"] = "\(isOpened)"
        return dictionary
    }
    
    func colorToString() -> String {
        if color == .red {
            return "red"
        } else if color == .blue {
            return "blue"
        } else {
            return "white"
        }
    }
}

