//
//  Media.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

class Media: NSObject {
    enum Genre {
        case NewsAndDocs
        case Entertainment
        case Kids
        case Sports
        case Music
    }
    
    var title: String?
    var duration: Int?
    var genre: Genre?
    var subGenre: String?
    var channel: String?
    var image: UIImage?
    
    init(title: String?, duration: Int?, genre: Genre?, subGenre: String?, channel: String?, image: NSURL?) {
        self.title = title
        self.duration = duration
        self.genre = genre
        self.subGenre = subGenre
        self.channel = channel
        if(image != nil){
            let data = NSData(contentsOfURL: image!);
            if(data != nil){
                self.image = UIImage(data: data!)
            }else{
                print("No image found for.. " + title!);
            }
        }
    }
}