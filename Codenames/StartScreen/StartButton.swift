import UIKit

final class StartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame.size.width = 40
        self.frame.size.height = 20
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


