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
    
    deinit {
        debugPrint("LoginViewController deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat app"
        navigationItem.setHidesBackButton(true, animated: true)
        setupView()
    }
    
    @IBAction func selectSignIn(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if shouldShowUsernameError() ||
            shouldShowPasswordError() {
            sender.isUserInteractionEnabled = true
            return
        }
        guard let data = signinStruct else {
            sender.isUserInteractionEnabled = true
            return
        }
        switch data.signInType {
        case .login:
            
            break
        case .register:
            signUp(usernameTxt: userName.text ?? "",
                   passwordTxt: password.text ?? "")
            break
        }
        
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
        if let usernameText = userName.text, !usernameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isAuthfailed {
            usernameErrorLbl.text = ""
            usernameErrorLblHeight.constant = 0
            return false
        }
        usernameErrorLbl.text = "Value is incorrect"
        usernameErrorLblHeight.constant = 35
        return true
    }
    
    func shouldShowPasswordError(_ isAuthfailed: Bool = false) -> Bool {
        if let passText = password.text, !passText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isAuthfailed && (passText.count >= 6 && passText.count <= 16) {
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
        
        passwordErrorLbl.text = ""
        passwordErrorLblHeight.constant = 0
        usernameErrorLbl.text = ""
        usernameErrorLblHeight.constant = 0
    }
    
    func login(usernameTxt: String, passwordTxt: String) {
        // - check first if user is existing,
        // otherwise, display error
        DataManager.shared.validateUser(with: usernameTxt) { [weak self] (exist) in
            guard let newSelf = self else {
                return
            }
            // - if user already exist,
            // display error message on both field
            if exist {
                DataManager.shared.retreiveEmail(with: usernameTxt) { (email) in
                    if email.isEmpty {
                        _ = newSelf.shouldShowUsernameError(true)
                        newSelf.signInBtn.isUserInteractionEnabled = true
                        return
                    }
                    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passwordTxt) { (authResult, error) in
                        guard authResult != nil, error == nil else {
                            _ = newSelf.shouldShowUsernameError(true)
                            newSelf.signInBtn.isUserInteractionEnabled = true
                            return
                        }
                        newSelf.redirectToConversation()
                    }
                }
            } else {
                _ = newSelf.shouldShowUsernameError(true)
                newSelf.signInBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    func signUp(usernameTxt: String, passwordTxt: String) {
        DataManager.shared.getNumberOfUsers { (count) in
            let newCount = count + 1
            DataManager.shared.validateUser(with: usernameTxt) { [weak self] (exist) in
                guard let newSelf = self else {
                    return
                }
                // - if user already exist,
                // display error message on both field
                if exist {
                    _ = newSelf.shouldShowUsernameError(true)
                    newSelf.signInBtn.isUserInteractionEnabled = true
                } else {
                    // otherwise, create user
                    // since email is not being supplied by user,
                    // I make a default email
                    FirebaseAuth.Auth.auth().createUser(withEmail: "userMail\(newCount)@chatapp.com", password: passwordTxt) { authResult, error in
                        
                        guard let result = authResult, error == nil else {
                            _ = newSelf.shouldShowUsernameError(true)
                            newSelf.signInBtn.isUserInteractionEnabled = true
                            return
                        }
                        DataManager.shared.insertUser(with: User(username: usernameTxt, email: result.user.email ?? "userMail\(newCount)@chatapp.com", uid: result.user.uid)) {
                            FirebaseAuth.Auth.auth().signIn(withEmail: "userMail\(newCount)@chatapp.com", password: passwordTxt) { (authResult, error) in
                                guard authResult != nil, error == nil else {
                                    _ = newSelf.shouldShowUsernameError(true)
                                    newSelf.signInBtn.isUserInteractionEnabled = true
                                    return
                                    
                                }
                                newSelf.redirectToConversation()
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func redirectToConversation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
