
import UIKit
import SnapKit

final class GameView: UIView {
    
    var wordButtons = [UIButton] ()
    var buttonTapped: ((UIColor, Int)->())?
    
    private var countOfColumns: CGFloat = 5.0
    private var countOfRows: CGFloat = 6.0
    private var wordsObjects: [WordObject]?
    
    init () {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(words: [WordObject], userType: UserType) {
        wordsObjects = words
        var buttonId = 0
        for row in 0...Int(countOfRows)-1 {
            for column in 0...Int(countOfColumns)-1 {
                let button = WordButton(frame: .zero)
                button.tag = buttonId
                button.setTitle(wordsObjects![buttonId].word, for: .normal)
                self.addSubview(button)
                
                button.snp.makeConstraints { make in
                    if row > 0 {
                        make.top.equalTo(self.snp.bottom).multipliedBy(1.0/countOfRows*CGFloat(row) )
                    } else {
                        make.top.equalTo(self.snp.top).inset(0)
                    }
                    if column > 0 {
                        make.leading.equalTo(self.snp.trailing).multipliedBy(1.0/countOfColumns * CGFloat(column))
                    } else {
                        make.leading.equalTo(self.snp.leading).inset(0)
                    }
                    make.width.equalTo(self.snp.width).multipliedBy(1.0/countOfColumns)
                    make.height.equalTo(self.snp.height).multipliedBy(1.0/countOfRows)
                }
                wordButtons.append(button)
                
                switch userType {
                case .captain:
                    button.backgroundColor = wordsObjects![buttonId].color
                    break
                case .player:
                    button.addTarget(self, action: #selector(wordButtonTapped(sender:)), for: .touchUpInside)
                }
                buttonId += 1
            }
        }
    }
    
    @objc private func wordButtonTapped(sender:UIButton) {
        guard wordsObjects != nil,
                buttonTapped != nil else {return}
        buttonTapped!(wordsObjects![sender.tag].color, sender.tag)
        if wordsObjects![sender.tag].color == .black {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Leader"), object: nil, userInfo: ["leader": "Game over"])
        } else if let team = wordsObjects![sender.tag].team  {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ButtonTapped"), object: nil, userInfo: ["Team" : team])
        }
    }
}
