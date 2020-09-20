//
//  Utils.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import Foundation
import UIKit
import NVActivityIndicatorView

struct ChatAppUtility {
    
    // this function will apply the rounded image effect
    static func applyRoundedCorners(img: UIImageView){
        // force border radius, use circular mask
        img.layer.cornerRadius = img.frame.size.height / 2;
        img.layer.masksToBounds = true
    }
    
    // this function will apply the rounded view effect
    static func applyRoundedCorners(view: UIView, cornerRadius: CGFloat){
        // force border radius, use circular mask
        view.layer.name = "roundCorner"
        view.layer.cornerRadius = cornerRadius;
        view.layer.masksToBounds = true
    }
    
    static func defaultAppFont(weight: String = "", fontSize: CGFloat = UIFont.systemFontSize) -> UIFont {
        let font = UIFont(name: "Verdana\(weight)", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        return font
    }
}

struct SignInStruc {
    var signInType: SignInType = .login
    
    func buttonText() -> String {
        if signInType == .login {
            return "Login"
        }
        return "Sign up"
    }
    
    func linkAttributedLinkText() -> NSMutableAttributedString {
        let linkAtrribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hexString: "6C767E"),
              .underlineStyle: NSUnderlineStyle.single.rawValue]
       return NSMutableAttributedString(string: signInType == .login ? "Sign Up" : "Login", attributes: linkAtrribute)
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        var rgbValue:UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

// extension for resetting the window on a UIKit application,
// Loading screen,
//
extension UIViewController {
    private func resetWindow(with vc: UIViewController?) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    func showViewController(with id: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        resetWindow(with: nav)
        
    }
    
    func displayLoadingScreen() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
}
