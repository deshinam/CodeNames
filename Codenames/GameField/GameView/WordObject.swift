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
    
    init() {
        self.id = 0
        self.word = ""
        self.color = .white
        self.team = nil
        self.isOpened = false
    }
    
    init(word: [String:String]) {
        self.init()
        self.id = word["id"] as? Int ?? 0
        self.word = word["word"] ?? ""
        self.color = self.stringColorToColor(str: word["color"] ?? "white")
        self.isOpened = (word["isOpened"] == "true")
        self.team = Team(rawValue: color)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        id = try container.decode(Int.self, forKey: .id)
        word = try container.decode(String.self, forKey: .word)
        isOpened = try container.decode(Bool.self, forKey: .isOpened)
        
        let colorString = try container.decode(String.self, forKey: .color)
        if colorString == "red" {
            color = Constants.redColor
        } else if colorString == "blue" {
            color = Constants.blueColor
        } else if colorString == "white"{
            color = Constants.grayColor
        } else {
            color = .black
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
        if color == Constants.redColor {
            return "red"
        } else if color == Constants.blueColor {
            return "blue"
        } else if color == Constants.grayColor {
            return "white"
        }
        else {
            return "black"
        }
    }
    
    func stringColorToColor(str: String) -> UIColor {
        if str == "red" {
            return Constants.redColor
        } else if str == "blue" {
            return Constants.blueColor
        } else if str == "white" {
            return Constants.grayColor
        } else {
            return .black
        }
    }
    
    

}

