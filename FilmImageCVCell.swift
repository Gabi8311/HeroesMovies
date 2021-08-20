import UIKit

final class FilmImageCVCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView()
    static let cellCVId = "CVCell"
    
    override init(frame: CGRect) {// Inicializa y devuelve un objeto de vista recién asignado con el rectángulo de marco especificado
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {// Devuelve un objeto inicializado a partir de datos en un desarchivador determinado
        super.init(coder: coder)
        setUpUI()
    }
    
    public func configureCell(_ dataUrl: String) {
        imageView.sd_setImage(with: URL(string: (dataUrl)))
    }
    
    func setUpUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        // Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor ).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        // Style
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
}
