//
//  ViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isHidden = true
        loginButton.addTarget(self, action: #selector(loginButtonWasPressed), for: .touchUpInside)

        signupButton.isHidden = true
        signupButton.addTarget(self, action: #selector(signupButtonWasPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AuthService.shared.loggedIn() {
            return performSegue(withIdentifier: "Main", sender: self)
        }

        loginButton.isHidden = false
        signupButton.isHidden = false
    }
    
    @objc private func loginButtonWasPressed() {
        performSegue(withIdentifier: "Login", sender: self)
    }
    
    @objc private func signupButtonWasPressed() {
        performSegue(withIdentifier: "Signup", sender: self)
    }
}

