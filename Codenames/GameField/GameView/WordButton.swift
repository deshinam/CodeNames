import UIKit

final class WordButton: UIButton {
    // MARK: — Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 3
        self.backgroundColor = .white
        self.setTitleColor(.darkGray, for: .normal)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


