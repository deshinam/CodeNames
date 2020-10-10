
import UIKit
import SnapKit

final class GameView: UIView {
    // MARK: — Private Properties
    private var countOfColumns: CGFloat = 5.0
    private var countOfRows: CGFloat = 6.0
    private var wordsObjects: [WordObject]?
    
    // MARK: — Public Properties
    var wordButtons = [UIButton] ()
    var buttonTapped: ((Int)->())?
    
    // MARK: — Initializers
    init () {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: — Private Methods
    @objc private func wordButtonTapped(sender:UIButton) {
        guard wordsObjects != nil,
              buttonTapped != nil else {return}
        buttonTapped!(sender.tag)
    }
    
    // MARK: — Public Methods
    func setupView(words: [WordObject], userType: UserType) {
        wordsObjects = words
        var buttonId = 0
        for row in 0...Int(countOfRows)-1 {
            for column in 0...Int(countOfColumns)-1 {
                let button = WordButton(frame: .zero)
                button.tag = buttonId
                // button.setTitle(gameWords[buttonId], for: .normal)
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
                    if wordsObjects![buttonId].isOpened {
                        button.backgroundColor = wordsObjects![buttonId].color
                    }
                    button.addTarget(self, action: #selector(wordButtonTapped(sender:)), for: .touchUpInside)
                }
                buttonId += 1
            }
        }
    }
    
    func updateButtonColors(words: [WordObject]) {
        for i in 0..<words.count {
            if words[i].isOpened {
                wordButtons[i].backgroundColor = words[i].color
            }
        }
    }
}
