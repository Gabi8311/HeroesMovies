import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    static let identifierCell = "movieCell"// Identificador estático para acceder a el desde cualquier parte
    
    func setMovieAndImage(title: String, image: String) -> Void {
        self.movieTitleLabel.text = title
        self.movieTitleLabel.textColor = UIColor .white
        self.movieTitleLabel.font = UIFont(name: "Copperplate", size: 28.0)
        self.movieImageView.sd_setImage(with: URL(string: image))
    }
    
    // Poner padding a la celda del ViewController
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25))
        self.movieImageView.layer.masksToBounds = true
        self.movieImageView.layer.cornerRadius = 8.0
    }

}
