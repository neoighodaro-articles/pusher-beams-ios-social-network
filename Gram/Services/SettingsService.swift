//
//  SettingsService.swift
//  Gram
//
//  Created by Neo Ighodaro on 27/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import Foundation
import Alamofire

class SettingsService: NSObject {

    static let shared = SettingsService()
    
    static let key = "gram.settings.notifications"
    
    var settings: [String: String] = [:];
    
    private var allSettings: [String: String] {
        set {
            self.settings = newValue
        }
        get {
            if let settings = loadFromDefaults(), settings["notificcation_comments"] != nil {
                return settings
            }
            
            return [
                "notification_comments": Setting.Notification.Comments.following.toString()
            ];
        }
    }
    
    override private init() {
        super.init()
        self.settings = self.allSettings
    }
    
    func loadFromDefaults() -> [String: String]? {
        return UserDefaults.standard.dictionary(forKey: SettingsService.key) as? [String: String]
    }
    
    func loadFromApi() {
        ApiService.shared.loadSettings { settings in
            if let settings = settings {
                self.allSettings = settings
                self.saveSettings(saveRemotely: false)
            }
        }
    }
    
    func updateCommentsNotificationSetting(_ status: Setting.Notification.Comments) {
        self.allSettings["notification_comments"] = status.toString()
        saveSettings()
    }
    
    func saveSettings(saveRemotely: Bool = true) {
        UserDefaults.standard.set(settings, forKey: SettingsService.key)
        
        if saveRemotely == true {
            ApiService.shared.saveSettings(settings: settings) { _ in }
        }
    }
    
}

enum Setting {
    
    enum Notification {

        enum Likes: String {
            case off = "Off"
            case following = "Following"
            case everyone = "Everyone"
            
            func toString() -> String {
                return self.rawValue
            }
        }
        
        enum Comments: String {
            case off = "Off"
            case following = "Following"
            case everyone = "Everyone"
            
            func toString() -> String {
                return self.rawValue
            }
        }
        
        enum Followers: String {
            case off = "Off"
            case everyone = "Everyone"
            
            func toString() -> String {
                return self.rawValue
            }
        }
    
    }
    
}
