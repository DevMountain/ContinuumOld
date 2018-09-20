//
//  Comment.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class Comment{
    
    fileprivate let typeKey = "Comment"
    fileprivate let textKey = "text"
    fileprivate let timestampKey = "timstamp"
    fileprivate let postReferenceKey = "postReference"
    
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?){
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}

extension CKRecord {
    convenience init(_ comment: Comment) {
        let recordID = CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: comment.typeKey, recordID: recordID)
        self.setValue(comment.text, forKey: comment.typeKey)
        self.setValue(comment.timestamp, forKey: comment.timestampKey)
    }
}

extension Comment: SearchableRecord{
    
    func matches(searchTerm: String) -> Bool {
        return self.text.lowercased().contains(searchTerm.lowercased())
    }
}
