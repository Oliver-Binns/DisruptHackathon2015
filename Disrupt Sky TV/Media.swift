//
//  Media.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import Foundation

class Media: NSObject {
    enum Genre {
        case NewsAndDocs
        case Entertainment
        case Kids
        case Sports
        case Music
    }
    
    var title: String?
    var duration: String?
    var genre: Genre?
    var subGenre: String?
    var channel: String?
    
    init(title: String?, duration: String?, genre: Genre?, subGenre: String?, channel: String?) {
        self.title = title
        self.duration = duration
        self.genre = genre
        self.subGenre = subGenre
        self.channel = channel
    }
}