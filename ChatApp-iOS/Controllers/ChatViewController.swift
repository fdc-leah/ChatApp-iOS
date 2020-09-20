//
//  ChatViewController.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {
    
    deinit {
        debugPrint("ChatViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func logoutUser(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            showViewController(with: "signupLogin")
        }catch {
            debugPrint("already logged out")
            showViewController(with: "signupLogin")
            
        }
    }
    
    func setupNaviBar() {
        title = "Chat app"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font : ChatAppUtility.defaultAppFont(weight: "-Bold", fontSize: 20)]
        
        navigationItem.setHidesBackButton(true, animated: true)
        let linkAtrribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font : ChatAppUtility.defaultAppFont(fontSize: 14)]
            
        let attributedStr = NSMutableAttributedString(string: "Log out", attributes: linkAtrribute)
        
        // Add logout button on right bar
        let btnLogout = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        btnLogout.setAttributedTitle(attributedStr, for: .normal)
        btnLogout.backgroundColor = UIColor(hexString: "666666")
        btnLogout.layer.cornerRadius = 4
        btnLogout.layer.masksToBounds = true
        btnLogout.addTarget(self, action: #selector(logoutUser(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnLogout)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

