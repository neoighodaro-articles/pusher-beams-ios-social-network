//
//  ApiService.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import Foundation
import Alamofire

class ApiService: NSObject {

    static let shared = ApiService()
        
    override private init() {
        super.init()
    }
    
    /// Logs a user into the application
    func login(credentials: AuthService.LoginCredentials, completion: @escaping(AuthService.AccessToken?, ApiError?) -> Void) {
        let params = [
            "username": credentials.email,
            "password": credentials.password,
            "grant_type": "password",
            "client_id": AppConstants.API_CLIENT_ID,
            "client_secret": AppConstants.API_CLIENT_SECRET
        ]
        
        request(.post, url: "/oauth/token", params: params, auth: false) { data in
            guard let data = data else { return completion(nil, .badCredentials) }
            guard let token = data["access_token"] as? String else { return completion(nil, .badResponse) }
            
            completion(token, nil)
        }
    }
    
    /// Creates a new account for a user
    func signup(credentials: AuthService.SignupCredentials, completion: @escaping(AuthService.AccessToken?, ApiError?) -> Void) {
        let params = [
            "name": credentials.name,
            "email": credentials.email,
            "password": credentials.password
        ]
        
        request(.post, url: "/api/register", params: params, auth: false) { data in
            guard let res = data, let data = res["data"] as? [String:AnyObject] else {
                return completion(nil, .badCredentials)
            }
            
            guard let token = data["access_token"] as? String else {
                return completion(nil, .badResponse)
            }
            
            completion(token, nil)
        }
    }
    
    /// Fetches a list of users
    func fetchUsers(completion: @escaping(Users?) -> Void) {
        request(.get, url: "/api/users") { data in
            if let data = self.responseToJsonStringData(response: data) {
                if let obj = try? JSONDecoder().decode(Users.self, from: data) {
                    return completion(obj)
                }
            }
            
            completion(nil)
        }
    }
    
    /// Fetches available posts
    func fetchPosts(completion: @escaping(Photos?) -> Void) {
        request(.get, url: "/api/photos") { data in
            if let data = self.responseToJsonStringData(response: data) {
                if let obj = try? JSONDecoder().decode(Photos.self, from: data) {
                    return completion(obj)
                }
            }
            
            completion(nil)
        }
    }
    
    /// Fetches comments for a photo
    func fetchComments(forPhoto id: Int, completion: @escaping(PhotoComments?) -> Void) {
        request(.get, url: "/api/photos/\(id)/comments") { data in
            if let data = self.responseToJsonStringData(response: data) {
                if let obj = try? JSONDecoder().decode(PhotoComments.self, from: data) {
                    return completion(obj)
                }
            }
            
            completion(nil)
        }
    }
    
    /// Leave a comment on a photo
    func leaveComment(forId id: Int, comment: String, completion: @escaping(PhotoComment?) -> Void) {
        request(.post, url: "/api/photos/\(id)/comments", params: ["comment": comment]) { data in
            if let res = data, let data = res["data"] as? [String: AnyObject],
                let json = try? JSONSerialization.data(withJSONObject: data, options: []),
                let jsonString = String(data: json, encoding: .utf8),
                let jsonData = jsonString.data(using: .utf8),
                let obj = try? JSONDecoder().decode(PhotoComment.self, from: jsonData) {
                    return completion(obj)
            }
            
            completion(nil)
        }
    }
    
    /// Follows or unfollows a user
    func toggleFollowStatus(forUserId id: Int, following: Bool, completion: @escaping(Bool?) -> Void) {
        let status = following ? "unfollow" : "follow"
        
        request(.post, url: "/api/users/\((status))", params: ["following_id": id]) { data in
            guard let res = data as? [String: String], res["status"] == "success" else {
                return completion(false)
            }
            
            completion(true)
        }
    }
    
    /// Loads a users settings
    func loadSettings(completion: @escaping([String: String]?) -> Void) {
        request(.get, url: "/api/users/settings") { data in
            guard let settings = data as? [String: String] else {
                return completion(nil)
            }
            
            completion(settings)
        }
    }

    /// Save the users settings
    func saveSettings(settings: [String: String], completion: @escaping(Bool) -> Void) {
        request(.put, url: "/api/users/settings", params: settings) { data in
            guard let res = data as? [String: String], res["status"] == "success" else {
                return completion(false)
            }
            
            completion(true)
        }
    }
    
    /// Uploads a new image to the API
    func uploadImage(_ image: Data, caption: String, name: String, completion: @escaping(Photo?, ApiError?) -> Void) {
        let url = self.url(appending: "/api/photos")
        
        // Handles multipart data
        let multipartHandler: (MultipartFormData) -> Void = { multipartFormData in
            multipartFormData.append(caption.data(using: .utf8)!, withName: "caption")
            multipartFormData.append(image, withName: "image", fileName: name, mimeType: "image/jpeg")
        }
        
        Alamofire.upload(
            multipartFormData: multipartHandler,
            usingThreshold: UInt64.init(),
            to: url,
            method: .post,
            headers: requestHeaders(),
            encodingCompletion: { encodingResult in
                let uploadedHandler: (DataResponse<Any>) -> Void = { response in
                    if response.result.isSuccess,
                        let resp = response.result.value as? [String: AnyObject],
                        let data = resp["data"] as? [String: AnyObject],
                        let json = try? JSONSerialization.data(withJSONObject: data, options: []),
                        let jsonString = String(data: json, encoding: .utf8),
                        let jsonData = jsonString.data(using: .utf8),
                        let obj = try? JSONDecoder().decode(Photo.self, from: jsonData) {
                            return completion(obj, nil)
                    }
                    
                    completion(nil, .uploadError(nil))
                }
            
                switch encodingResult {
                case .failure(_): completion(nil, .uploadError(nil))
                case .success(let upload, _, _): upload.responseJSON(completionHandler: uploadedHandler)
                }
            }
        )
    }
    
}


private extension ApiService {
    
    func url(appending: URLConvertible) -> URLConvertible {
        return "\(AppConstants.API_URL)\(appending)"
    }
    
    func requestHeaders(auth: Bool = true) -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        
        if auth && AuthService.shared.loggedIn() {
            headers["Authorization"] = "Bearer \(AuthService.shared.getToken()!)"
        }

        return headers
    }
    
    /// Sends a request using Alamofire
    func request(_ method: HTTPMethod, url: URLConvertible, params: Parameters? = nil, auth: Bool = true, handler: @escaping ([String: AnyObject]?) -> Void) {
        let url = self.url(appending: url)
        
        Alamofire
            .request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: requestHeaders(auth: auth))
            .validate()
            .responseJSON { resp in
                guard resp.result.isSuccess, let data = resp.result.value as? [String: AnyObject] else {
                    return handler(nil)
                }
                
                handler(data)
            }
    }
    
    /// Converts the response to json data
    func responseToJsonStringData(response data: [String: AnyObject]?) -> Data? {
        if let res = data, let data = res["data"] as? [[String: AnyObject]] {
            if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                if let jsonString = String(data: json, encoding: .utf8), let data = jsonString.data(using: .utf8) {
                    return data
                }
            }
        }
        
        return nil
    }

}


enum ApiError: Error {
    case badResponse
    case badCredentials
    case uploadError([String: [String]]?)
}
