//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by John Clema on 26/08/2015.
//  Copyright (c) 2015 JohnClema. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathURL: NSURL!
    var title: String!
    
    init(filePathURL: NSURL) {
        self.title = filePathURL.lastPathComponent
        self.filePathURL = filePathURL
    }
    
}