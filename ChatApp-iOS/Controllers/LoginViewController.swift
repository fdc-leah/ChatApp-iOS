//
//  LoginViewController.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var usernameErrorLbl: UILabel!
    @IBOutlet weak var usernameErrorLblHeight: NSLayoutConstraint!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLblHeight: NSLayoutConstraint!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var othersignInLink: UIButton!
    
    var signinStruct: SignInStruc?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat app"
        navigationItem.setHidesBackButton(true, animated: true)
        setupView()
    }
    
    @IBAction func selectSignIn(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if shouldShowUsernameError(isFirstLoad: false) &&
            shouldShowPasswordError(isFirstLoad: false) {
            sender.isUserInteractionEnabled = true
            return
        }
        login(userName)
        
    }
    
    @IBAction func selectOtherSignInOptn(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        guard let navigationVC = navigationController else { return }
        navigationVC.popViewController(animated: false)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        let signInType: SignInType = signinStruct!.signInType == .login ? .register : .login
        vc.signinStruct = SignInStruc(signInType: signInType)
        navigationVC.pushViewController(vc, animated: true)
        sender.isUserInteractionEnabled = true
        
    }
    func shouldShowUsernameError(_ isAuthfailed: Bool = false) -> Bool {
        if let usernameText = userName.text, !usernameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAuthfailed {
            usernameErrorLbl.text = ""
            usernameErrorLblHeight.constant = 0
            return false
        }
        usernameErrorLbl.text = "Value is incorrect"
        usernameErrorLblHeight.constant = 35
        return true
    }
    
    func shouldShowPasswordError(_ isAuthfailed: Bool = false) -> Bool {
        if let passText = password.text, !passText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAuthfailed || (passText.count >= 6 && passText.count <= 16) {
            passwordErrorLbl.text = ""
            passwordErrorLblHeight.constant = 0
            return false
        }
        passwordErrorLbl.text = "Value is incorrect"
        passwordErrorLblHeight.constant = 35
        return true
    }
    
    func setupView() {
        guard let data = signinStruct else {
            return
        }
        
        ChatAppUtility.applyRoundedCorners(view: signInBtn, cornerRadius: 10)
        signInBtn.setTitle(data.buttonText(), for: .normal)
        othersignInLink.setAttributedTitle(data.linkAttributedLinkText(), for: .normal)
        _ = shouldShowUsernameError()
        _ = shouldShowPasswordError()
    }
    
    func login(usernameTxt: String, passwordTxt: String) {
    }
    
    func signUp(usernameTxt: String, passwordTxt: String) {
        DataManager.shared.validateUser(with: passwordTxt) { [weak self] (exist) in
            guard let newSelf = self else {
                return
            }
            // - if user already exist,
            // display error message on both field
            if exist {
                _ = newSelf.shouldShowUsernameError(true)
                _ = newSelf.shouldShowPasswordError(true)
            } else {
                // otherwise, create user
                FirebaseAuth.Auth.auth().createUser(withEmail: usernameTxt, password: passwordTxt) { authResult, error in
                    
                    guard let result = authResult, error == nil else {
                        debugPrint("error firebase login ")
                        return
                    }
                    
                }
            }
        }
        
    }
    
}
