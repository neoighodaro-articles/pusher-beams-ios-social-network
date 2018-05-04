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
            guard let settings = loadFromDefaults(),
                settings["notification_likes"] != nil,
                settings["notificcation_comments"] != nil,
                settings["notification_followers"] != nil else {
                    return [
                        "likes": Setting.Notification.Likes.following.toString(),
                        "comments": Setting.Notification.Comments.following.toString(),
                        "new_follower": Setting.Notification.Followers.everyone.toString()
                    ];
            }
            
            return settings
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
    
    func updateLikesNotificationSetting(_ status: Setting.Notification.Likes) {
        self.allSettings["notification_likes"] = status.toString()
        saveSettings()
    }
    
    func updateCommentsNotificationSetting(_ status: Setting.Notification.Comments) {
        self.allSettings["notification_comments"] = status.toString()
        saveSettings()
    }

    func updateNewFollowersNotificationSetting(_ status: Setting.Notification.Followers) {
        self.allSettings["notification_followers"] = status.toString()
        saveSettings()
    }
    
    func saveSettings(saveRemotely: Bool = true) {
        UserDefaults.standard.set(settings, forKey: SettingsService.key)
        
        if saveRemotely {
            ApiService.shared.saveSettings(settings: settings) { saved in }
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
