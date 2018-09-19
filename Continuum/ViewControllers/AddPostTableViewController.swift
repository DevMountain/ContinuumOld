//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        selectPhotoButton.setTitle("Select a Photo", for: .normal)
        photoImageView.image = nil
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        photoImageView.image = #imageLiteral(resourceName: "jellies")
        selectPhotoButton.setTitle("", for: .normal)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let photo = photoImageView.image, let caption = captionTextField.text, !caption.isEmpty else {return}
        PostController.shared.createPostWith(image: photo, captionText: caption) { (_) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    
}
