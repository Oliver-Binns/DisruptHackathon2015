//
//  ViewController.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit
import SystemConfiguration
import MapKit

extension CLLocationManager {
    class var sharedManager : CLLocationManager {
        struct Singleton {
            static let instance = CLLocationManager()
        }
        return Singleton.instance
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func locationButtonTapped(sender: AnyObject) {
        let locationManager = CLLocationManager.sharedManager
        
        locationManager.requestAlwaysAuthorization() //Displays alert view to request location use
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        
        print(locationManager.location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

