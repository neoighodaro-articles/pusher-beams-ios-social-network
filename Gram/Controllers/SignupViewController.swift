//
//  SignupViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBOutlet weak var signupButton: UIBarButtonItem!
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateSignupButtonIfNecessary()
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    // MARK: IBAction methods
    
    @IBAction func closeButtonWasPressed(_ sender: Any? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonWasPressed(_ sender: Any) {
        guard let credentials = textFields(), signupButton.isEnabled else {
            return
        }
        
        ApiService.shared.signup(credentials: credentials) { token, error in
            guard let token = token, error == nil else {
                return StatusBarNotificationBanner(title: "Signup failed. Try again.", style: .danger).show()
            }
            
            AuthService.shared.saveToken(token).then {
                self.closeButtonWasPressed()
            }
        }
    }
    
}


// MARK: - Helper methods

private extension SignupViewController {
    
    func textFields() -> AuthService.SignupCredentials? {
        if let name = nameTextField.text, let email = emailTextField.text, let pass = passwordTextfield.text {
            return (name, email, pass)
        }
        
        return nil
    }

    func activateSignupButtonIfNecessary() {
        if let field = textFields() {
            signupButton.isEnabled = !field.name.isEmpty && !field.email.isEmpty && !field.password.isEmpty
        }
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        activateSignupButtonIfNecessary()
    }
    
}
