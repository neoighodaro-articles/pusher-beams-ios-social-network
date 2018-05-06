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

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        SettingsService.shared.loadFromApi()
        
        self.reloadButtonWasPressed()
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
        
        guard let user = photo["user"] as? [String: AnyObject] else {
            return cell
        }

        cell.delegate = self
        cell.indexPath = indexPath
        cell.nameLabel.text = user["name"] as? String
        
        if let imageUrl = photo["image"] as? String {
            Alamofire.request(imageUrl).responseData { response in
                if response.error == nil, let data = response.data {
                    cell.photo.image = UIImage(data: data)
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
            if let image = UIImageJPEGRepresentation(selectedImage, 0) {
                self.dismiss(animated: true, completion: {
                    var caption: UITextField?
                    
                    let alert = UIAlertController(title: "Add Caption", message: "Add a caption", preferredStyle: .alert)
                    
                    alert.addTextField { textField in caption = textField }
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                        var fileName = "uploadedImage.jpg"
                        let caption = (caption?.text)!
                        
                        if let url = info[UIImagePickerControllerImageURL] as? NSURL, let realName = url.lastPathComponent {
                            fileName = realName
                        }
                        
                        ApiService.shared.uploadImage(image, caption: caption, name: fileName) { data, error in
                            guard let photo = data, let id = photo["id"] as? Int, error == nil else {
                                return StatusBarNotificationBanner(title: "Failed to upload image", style: .danger).show()
                            }

                            try? PushNotifications.shared.subscribe(interest: "photo_\(id)-comment_following")
                            try? PushNotifications.shared.subscribe(interest: "photo_\(id)-comment_everyone")
                            
                            self.photos.insert(photo, at: 0)
                            self.tableView.reloadData()
                            
                            StatusBarNotificationBanner(title: "Uploaded successfully", style: .success).show()
                        }
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }

}
