//
//  ChatViewController.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit

class ChatViewController: UIViewController {
    
    deinit {
        debugPrint("ChatViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func logoutUser(_ sender: UIBarButtonItem) {
        
    }
    
    func setupRightButtonBar() {
        let linkAtrribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hexString: "6C767E"),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font : ChatAppUtility.defaultAppFont(fontSize: 14)]
            
        let attributedStr = NSMutableAttributedString(string: "Log out", attributes: linkAtrribute)
        
        // Add logout button on right bar
        let btnLogout = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        btnLogout.setAttributedTitle(attributedStr, for: .normal)
        btnLogout.backgroundColor = UIColor(hexString: "666666")
        btnLogout.layer.cornerRadius = 4
        btnLogout.layer.masksToBounds = true
        btnLogout.addTarget(self, action: #selector(logoutUser(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnLogout)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

