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
    
    var posts = [Post]()
    
    func addComment(_ text: String, to post: Post, completion: (Comment) -> ()){
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(image: UIImage, comment: Comment){
        let post = Post(photo: image, comments: [comment])
        self.posts.append(post)
    }
}
