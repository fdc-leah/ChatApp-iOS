//
//  SignUpLoginViewController.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit

class SignUpLoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    deinit {
        debugPrint("deinit SignUpLoginViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply corner radius to button
        ChatAppUtility.applyRoundedCorners(view: loginBtn, cornerRadius: 10)
        ChatAppUtility.applyRoundedCorners(view: signUpBtn, cornerRadius: 10)
        
        // set button tags according to its enum
        loginBtn.tag = SignInType.login.rawValue
        signUpBtn.tag = SignInType.register.rawValue
    }
    
    @IBAction func userSignIn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.signinStruct = SignInStruc(signInType: SignInType.init(rawValue: sender.tag) ?? .login)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}
