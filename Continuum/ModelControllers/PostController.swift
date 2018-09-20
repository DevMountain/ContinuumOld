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
    
    func createPostWith(image: UIImage, captionText: String, completion: @escaping (Post) -> ()){
//        let post = Post(photo: image, captionText: captionText)
//        
//      
//        publicDB.save(<#T##record: CKRecord##CKRecord#>, completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
//        comment.post = post
//        self.posts.append(post)
    }
}
