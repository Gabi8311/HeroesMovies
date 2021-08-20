import UIKit

extension UILabel {
    
    func moving(_ view: MoreDetailsViewController) {
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30, options: .curveEaseInOut, animations: ({
            self.center.x = view.accessibilityFrame.width / 2
        }), completion: nil)
    }}
