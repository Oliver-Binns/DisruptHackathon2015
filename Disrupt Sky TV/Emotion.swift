//
//  Emotion.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 06/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit

enum Emotion {
    case Happy
    case KeepVibe
    case Sad
    case Anger
    case Love
    case Cheeky
    
    var description: String{
        switch self{
        case Happy:
            return "Cheer Me Up"
        case KeepVibe:
            return "More Like This"
        case Sad:
            return "Make Me Cry"
        case Anger:
            return "Let Me Vent"
        case Love:
            return "Let's Get It On"
        case Cheeky:
            return "Give Me Nandos"
        }
    }
    
    var image: UIImage{
        switch self{
        case Happy:
            return UIImage(named: "Happy")!
        case KeepVibe:
            return UIImage(named: "KeepVibe")!
        case Sad:
            return UIImage(named: "Sad")!
        case Anger:
            return UIImage(named: "Anger")!
        case Love:
            return UIImage(named: "Love")!
        case Cheeky:
            return UIImage(named: "Cheeky")!
        }
    }
}
