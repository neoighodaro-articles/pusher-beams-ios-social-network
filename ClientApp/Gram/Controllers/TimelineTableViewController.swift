//
//  TimelineTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 28/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import Alamofire
import NotificationBannerSwift
import PushNotifications

class TimelineTableViewController: UITableViewController {
    
    var photos: [[String: AnyObject]] = []
    
    var selectedPhoto: [String: AnyObject]?
    
    let picker = UIImagePickerController()
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadButtonWasPressed()
        
        self.picker.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func userButtonWasPressed(_ sender: Any) {
        AuthService.shared.logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reloadButtonWasPressed(_ sender: Any? = nil) {
        ApiService.shared.fetchPosts { photos in
            if let photos = photos {
                self.photos = photos
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonWasPressed(_ sender: Any) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.barButtonItem = nil
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CommentsTableViewController, let photo = selectedPhoto {
            if let comments = photo["comments"] as? [[String: AnyObject]], let id = photo["id"] as? Int {
                selectedPhoto = nil
                vc.photoId = id
                vc.comments = comments
            }
        }
    }
    
}


// MARK: - Table controller delegate

extension TimelineTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoListTableViewCell
        
        if let user = photo["user"] as? [String: AnyObject] {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.nameLabel.text = user["name"] as? String
            cell.photo.image = UIImage(named: "loading")
            
            if let imageUrl = photo["image"] as? String {
                Alamofire.request(imageUrl).responseData { response in
                    if response.error == nil, let data = response.data {
                        cell.photo.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }

}


// MARK: - Photo list cell delegate

extension TimelineTableViewController: PhotoListCellDelegate {
    
    func commentButtonWasTapped(at indexPath: IndexPath) {
        self.selectedPhoto = photos[indexPath.row]
        self.performSegue(withIdentifier: "Comments", sender: self)
    }
    
}


// MARK: - Image Picker

extension TimelineTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            guard let image = UIImageJPEGRepresentation(selectedImage, 0) else { return }
            
            let uploadPhotoHandler: (() -> Void)? = {
                var caption: UITextField?
                
                let alert = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
                alert.addTextField(configurationHandler: { textfield in caption = textfield })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                    var filename = "upload.jpg"
                    let caption = caption?.text ?? "No caption"
                    
                    if let url = info[UIImagePickerControllerImageURL] as? NSURL, let name = url.lastPathComponent {
                        filename = name
                    }
                    
                    ApiService.shared.uploadImage(image, caption: caption, name: filename) { data, error in
                        guard let photo = data, let id = photo["id"] as? Int, error == nil else {
                            return StatusBarNotificationBanner(title: "Failed to upload image", style: .danger).show()
                        }
                        
                        try? PushNotifications.shared.subscribe(interest: "photo_\(id)-comment_following")
                        try? PushNotifications.shared.subscribe(interest: "photo_\(id)-comment_everyone")
                        
                        self.photos.insert(photo, at: 0)
                        self.tableView.reloadData()
                        
                        StatusBarNotificationBanner(title: "Uploaded successfully", style: .success).show()
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
            }

            self.dismiss(animated: true, completion: uploadPhotoHandler)
        }
    }

}
