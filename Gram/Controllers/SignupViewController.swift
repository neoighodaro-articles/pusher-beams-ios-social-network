//
//  SignupViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateSignupButtonIfNecessary()
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    private func textFields() -> AuthService.SignupCredentials? {
        guard let name = nameTextField.text, let email = emailTextField.text, let pass = passwordTextfield.text else {
            return nil
        }
        
        return (name, email, pass)
    }
    
    @objc private func activateSignupButtonIfNecessary() {
        guard let the = textFields() else { return }
        
        signupButton.isEnabled = !the.name.isEmpty && !the.email.isEmpty && !the.password.isEmpty
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        activateSignupButtonIfNecessary()
    }

    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonWasPressed(_ sender: Any) {
        guard let credentials = textFields() else { return }
        
        ApiService.shared.signup(credentials: credentials) { token, error in
            guard let token = token, error == nil else { return print("Signup failed") }
            
            AuthService.shared.saveToken(token).then {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
