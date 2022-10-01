//
//  Extensions.swift
//  attendance
//
//  Created by TechCenter on 04/05/22.
//

import Foundation
import UIKit
struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIView {
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 0.3
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 0.3 )
    }
    
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        //layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }

}


extension UIViewController {
    func LoadingStart(){
         ProgressDialog.alert = UIAlertController(title: nil, message: "Loading ...", preferredStyle: .alert)
     let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
     loadingIndicator.hidesWhenStopped = true
     loadingIndicator.style = UIActivityIndicatorView.Style.gray
     loadingIndicator.startAnimating();
     ProgressDialog.alert.view.addSubview(loadingIndicator)
     present(ProgressDialog.alert, animated: true, completion: nil)
   }

   func LoadingStop(){
     ProgressDialog.alert.dismiss(animated: true, completion: nil)
   }

    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> HomeVC? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is HomeVC {
            return viewController! as? HomeVC
        }
        while (!(viewController is HomeVC) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is HomeVC {
            return viewController as? HomeVC
        }
        return nil
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: (self.view.frame.size.height / 2) - 17, width: 300, height: 70))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        
        toastLabel.frame.size = CGSize(width: toastLabel.frame.width, height: (35 * CGFloat(toastLabel.actualNumberOfLines)))
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 3.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension UILabel {
    var actualNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension Date {
    func today(format : String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
