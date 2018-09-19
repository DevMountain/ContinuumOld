//
//  Comment.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class Comment{
    
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?){
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}

extension Comment: SearchableRecord{
    
    func matches(searchTerm: String) -> Bool {
        return self.text.contains(searchTerm)
    }
}
