import UIKit

final class CarouselCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    private lazy var textLabel = UILabel()
    private lazy var textDescription = UITextView()
    private lazy var buttonMoreDetails = UIButton()
    private weak var delegate: DelegateMoreDetailsProtocol!
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"// Podremos acceder al ID desde cualquier parte -> CarouselCell.cellId
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {// Inicializa y devuelve un objeto de vista recién asignado con el rectángulo de marco especificado
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {// Devuelve un objeto inicializado a partir de datos en un desarchivador determinado
        super.init(coder: coder)
        setUpUI()
    }
    
}

// MARK: - Setups

private extension CarouselCell {// Las extensiones en Swift nos proporcionan la capacidad de ampliar la funcionalidad de una clase, estructura, enumeración o protocolo.
    func setUpUI() {
        backgroundColor = .clear
        addSubviews(imageView, textLabel, textDescription, buttonMoreDetails)
        prepareSubview(imageView, textLabel, textDescription, buttonMoreDetails)
    }
    
    @objc func moreDetails() {// Func que se ejecutará cuando pulsemos buttonMoreDetails
        sleep(1)
        self.delegate.enterToMoreDetails()
    }
    
    private func addSubviews(_ imgView: UIImageView, _ label: UILabel, _ textView: UITextView, _ button: UIButton) {
        addSubview(imgView)
        addSubview(label)
        addSubview(textView)
        addSubview(button)
    }
    
    private func prepareSubview(_ imgView: UIImageView, _ label: UILabel, _ textView: UITextView, _ button: UIButton) {
        prepareConstraits(imgView, label, textView, button)
        prepareStyles(imgView, label, textView, button)
    }
    
    private func prepareConstraits(_ imgView: UIImageView, _ label: UILabel, _ textView: UITextView, _ button: UIButton) {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.topAnchor.constraint(equalTo: topAnchor ).isActive = true
        imgView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imgView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imgView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -130).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 70).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 180).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 85).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -85).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
    }
    
    private func prepareStyles(_ imgView: UIImageView, _ label: UILabel, _ textView: UITextView, _ button: UIButton) {
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 24
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Copperplate", size: 30.0)
        label.textColor = .darkGray
        
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.isEditable = false
        textView.font = UIFont(name: "Avenir-Light", size: 16.0)
        textView.backgroundColor = .none
        
        button.frame = CGRect(x: 90, y: 600, width: 120, height: 30)
        button.setTitle("More Details", for: .normal)
        button.setTitle("Loading . . .", for: .highlighted)
        button.backgroundColor = UIColor .lightGray
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor .white.cgColor
        button.layer.shadowColor = UIColor .darkGray.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.addTarget(self, action: #selector(moreDetails), for: .touchUpInside)
        // --> Si pongo aquí la func pulsate, desaparece cuando vuelvo a esa pantalla desde moreDetails <-- //
    }
    
}

// MARK: - Public

extension CarouselCell {
    
    public func configure(data: CarouselData, delegate: DelegateMoreDetailsProtocol?) {
        // Se hace esto para cargar todas las películas directamente(anteriormente sólo se cargaban las que veías y las demás no aparecían)
        
        self.delegate = delegate
        
        textLabel.text = data.text
        textDescription.text = data.description
        
        if let url = data.url {
            imageView.sd_setImage(with: URL(string: (url)))
        }else if let img = data.image {
            imageView.image = img
        }
        
        self.buttonMoreDetails.pulsate()// Se va cuando paso del 3er movimiento. POR QUÉ?? Cumple SOLID??
    }
    
}
