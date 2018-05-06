//
//  AppDelegate.swift
//  Gram
//
//  Created by Neo Ighodaro on 25/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.pushNotifications.start(instanceId: AppConstants.PUSHER_INSTANCE_ID)
        self.pushNotifications.registerForRemoteNotifications()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
}

