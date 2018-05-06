//
//  LoginViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateLoginButtonIfNecessary()
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    // MARK: IBAction methods

    @IBAction func closeButtonWasPressed(_ sender: Any? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        guard let credentials = textFields(), loginButton.isEnabled else {
            return
        }
        
        ApiService.shared.login(credentials: credentials) { token, error in
            guard let token = token, error == nil else {
                return StatusBarNotificationBanner(title: "Login failed, try again.", style: .danger).show()
            }
            
            AuthService.shared.saveToken(token).then {
                self.closeButtonWasPressed()
            }
        }
    }
    
}


// MARK: - Helper methods

private extension LoginViewController {
    
    func textFields() -> AuthService.LoginCredentials? {
        if let email = emailTextField.text, let password = passwordTextField.text {
            return (email, password)
        }
        
        return nil
    }
    
    func activateLoginButtonIfNecessary() {
        if let field = textFields() {
            loginButton.isEnabled = !field.email.isEmpty && !field.password.isEmpty
        }
    }

    @objc func textFieldChanged(_ sender: UITextField) {
        activateLoginButtonIfNecessary()
    }

}
