//
//  LoginViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateLoginButtonIfNecessary()
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    private func textFields() -> AuthService.LoginCredentials? {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return nil
        }
        
        return (email, password)
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        activateLoginButtonIfNecessary()
    }
    
    @objc private func activateLoginButtonIfNecessary() {
        guard let the = textFields() else { return }
        
        loginButton.isEnabled = !the.email.isEmpty && !the.password.isEmpty
    }

    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        guard let credentials = textFields() else { return }
        
        ApiService.shared.login(credentials: credentials) { token, error in
            guard let token = token, error == nil else { return print("Login failed") }
            
            AuthService.shared.saveToken(token).then {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
