//
//  Post.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class Post{
    
    var photoData: Data?
    var timestamp: Date
    var comments: [Comment]
    
    var photo: UIImage?{
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.6)
        }
    }
    
    init(photo: UIImage, comments: [Comment], timestamp: Date = Date()){
        self.comments = comments
        self.timestamp = timestamp
        self.photo = photo
    }
}

extension Post: SearchableRecord{
    
    func matches(searchTerm: String) -> Bool {
        for comment in self.comments{
            if comment.matches(searchTerm: searchTerm){
                return true
            }
        }
        return false
    }
}
