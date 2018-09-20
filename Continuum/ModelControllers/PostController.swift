//
//  PostController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController{
    
    static let shared = PostController()
    private init() {}
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var posts = [Post]()
    
    
    func addComment(_ text: String, to post: Post, completion: (Comment) -> ()){
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(captionText: String, photo: UIImage, completion: @escaping (Post?) -> ()){
        let post = Post(caption: captionText, photo: photo)
        self.posts.append(post)
        publicDB.save(CKRecord(post)) { (_, error) in
            if let error = error {
                print("Error saving post record \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            completion(post)
        }
    }
}
