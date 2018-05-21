//
//  Photo.swift
//  Gram
//
//  Created by Neo Ighodaro on 20/05/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import Foundation

typealias Users = [User]
typealias Photos = [Photo]
typealias PhotoComments = [PhotoComment]

struct User: Codable {
    
    var id: Int
    var name: String
    var email: String
    var follows: Bool?
    
}

struct Photo: Codable {
    
    var id: Int
    var user: User
    var image: String
    var caption: String
    var comments: PhotoComments
    
}

struct PhotoComment: Codable {
    
    var id: Int
    var user: User
    var photo_id: Int
    var user_id: Int
    var comment: String
    
}
