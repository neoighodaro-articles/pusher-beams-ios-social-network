//
//  NotificationService.swift
//  Notification
//
//  Created by Neo Ighodaro on 06/05/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        func failEarly() {
            contentHandler(request.content)
        }
        
        guard
            let content = (request.content.mutableCopy() as? UNMutableNotificationContent),
            let apnsData = content.userInfo["data"] as? [String: Any],
            let photoURL = apnsData["attachment-url"] as? String,
            let attachmentURL = URL(string: photoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
            let imageData = try? NSData(contentsOf: attachmentURL, options: NSData.ReadingOptions()),
            let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.png", data: imageData, options: nil)
            else {
                return failEarly()
        }
        
        content.attachments = [attachment]
        contentHandler(content.copy() as! UNNotificationContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
