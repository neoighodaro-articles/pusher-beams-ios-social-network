//
//  AuthService.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import Foundation

class AuthService: NSObject {
    
    static let key = "gram-tokenx"
    
    static let shared = AuthService()
    
    typealias AccessToken = String
    
    typealias LoginCredentials = (email: String, password: String)
    
    typealias SignupCredentials = (name: String, email: String, password: String)

    
    override private init() {
        super.init()
    }
    
    func loggedIn() -> Bool {
        return getToken() != nil
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: AuthService.key)
    }
    
    func getToken() -> AccessToken? {
        return UserDefaults.standard.string(forKey: AuthService.key)
    }

    func saveToken(_ token: AccessToken) -> AuthService {
        UserDefaults.standard.set(token, forKey: AuthService.key)
        return self
    }
    
    func deleteToken() -> AuthService {
        UserDefaults.standard.removeObject(forKey: AuthService.key)
        return self
    }
    
    func then(completion: @escaping() -> Void) {
        completion()
    }
}
