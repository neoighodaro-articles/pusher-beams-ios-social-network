//
//  ViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isHidden = true
        signupButton.isHidden = true

        loginButton.addTarget(self, action: #selector(loginButtonWasPressed), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonWasPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard AuthService.shared.loggedIn() == false else {
            SettingsService.shared.loadFromApi()
            return performSegue(withIdentifier: "Main", sender: self)
        }
        
        loginButton.isHidden = false
        signupButton.isHidden = false
    }
    
}


// MARK: - Actions

@objc private extension LaunchViewController {
    
    func loginButtonWasPressed() {
        performSegue(withIdentifier: "Login", sender: self)
    }
    
    func signupButtonWasPressed() {
        performSegue(withIdentifier: "Signup", sender: self)
    }
    
}

