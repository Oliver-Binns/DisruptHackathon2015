//
//  HomeViewController.swift
//  Disrupt Sky TV
//
//  Created by Oliver on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?;
    @IBOutlet var collectionView: UICollectionView!
    
    let timeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //SETUP Device IDs
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setValue("7bb60c9bf819183910b2473288388d834518ea2a", forKey: "subscriberId");
        defaults.setValue("enihdiehqwtfw", forKey: "deviceId");
        defaults.synchronize();
        
        //SETUP Location
        self.locationManager = CLLocationManager.sharedManager
        self.locationManager!.delegate = self;
        self.locationManager!.requestAlwaysAuthorization() //Displays alert view to request location use
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager!.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        
        let rightBarButtonItemOne: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings Icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "oneTapped:")
        rightBarButtonItemOne.tintColor = UIColor.whiteColor()
        let rightBarButtonItemTwo: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Notification Icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "twoTapped:")
        rightBarButtonItemTwo.tintColor = UIColor.whiteColor()
        let rightBarButtonItemThree: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search Icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "threeTapped:")
        rightBarButtonItemThree.tintColor = UIColor.whiteColor()

        self.navigationItem.setRightBarButtonItems([rightBarButtonItemOne, rightBarButtonItemTwo, rightBarButtonItemThree], animated: true)
        
        timeLabel.textAlignment = NSTextAlignment.Left
        timeLabel.frame = CGRectMake(0, 0, view.frame.width, (self.navigationController?.navigationBar.frame.height)!)
        timeLabel.textColor = UIColor.whiteColor()
        
        self.navigationItem.titleView = timeLabel
        
        updateTime()
        var _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        DataManager.sharedInstance.apiRequest(self.locationManager!.location!.coordinate, callback: printData);
    }
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if(newLocation.distanceFromLocation(oldLocation) > 500){
            DataManager.sharedInstance.apiRequest(self.locationManager!.location!.coordinate, callback: printData);
        }
    }
    
    func printData(succeeded: Bool, request: [Media]){
        for(var i = 0; i < request.count; i++){
            print(request[i].title);
        }
    }
    
    func updateTime() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Hour.union(.Minute)
        let components = calendar.components(unit, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        var timeString: String!
        if String(minutes).characters.count == 1 {
            timeString = "\(hour):0\(minutes) | "
        } else {
            timeString = "\(hour):\(minutes) | "
        }
        
        var timeOfDayString: String!
        if hour >= 0 && hour < 12 {
            timeOfDayString = "Morning"
        } else if hour >= 12 && hour < 17 {
            timeOfDayString = "Afternoon"
        } else if hour >= 17 {
            timeOfDayString = "Night"
        }
        
        let attributedString = NSMutableAttributedString(string: timeString)
        
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        let boldString = NSMutableAttributedString(string: timeOfDayString, attributes: attributes)
        
        attributedString.appendAttributedString(boldString)
        
        timeLabel.attributedText = attributedString
        
        self.navigationItem.titleView = timeLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 30 //Replace with recommendations.count
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print(indexPath.section)
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resumeCell", forIndexPath: indexPath) as! ResumeCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentCell", forIndexPath: indexPath) as! ContentCell
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let resumeWidth = floor(view.frame.width)
        let contentWidth = floor(view.frame.width / 4)
        
        if indexPath.section == 0 {
            return CGSizeMake(resumeWidth, resumeWidth)
        } else {
            return CGSizeMake(contentWidth - 5, contentWidth / 2)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
