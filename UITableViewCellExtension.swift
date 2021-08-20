import UIKit

extension UITableViewCell {
    func bounce() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }) {
            (completion) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = .identity
            })
        }
    }
}
