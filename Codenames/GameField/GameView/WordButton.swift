import UIKit

final class WordButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 3
        self.backgroundColor = .white
        self.setTitleColor(.darkGray, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


