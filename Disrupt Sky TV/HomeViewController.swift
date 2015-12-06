//
//  HomeViewController.swift
//  Disrupt Sky TV
//
//  Created by Oliver on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    var lightBlur = UIBlurEffect()
    var blurRandomView = UIVisualEffectView()
    let overlayView = UIView()
    var locationManager: CLLocationManager?
    var media = Dictionary<Emotion, [Media]>();
    var moviePlayerVC = AVPlayerViewController();
    var videoPlaying = false;
    
    @IBOutlet var collectionView: UICollectionView!
    
    let timeLabel = UILabel()
    let navView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //SETUP Device IDs
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("7bb60c9bf819183910b2473288388d834518ea2a", forKey: "subscriberId")
        defaults.setValue("enihdiehqwtfw", forKey: "deviceId")
        defaults.synchronize()
        
        //SETUP Location
        self.locationManager = CLLocationManager.sharedManager
        self.locationManager!.delegate = self
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
        
        navView.frame = CGRectMake(0, 0, view.frame.width, (self.navigationController?.navigationBar.frame.height)!)
        
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.frame = CGRectMake(view.frame.width / 3, 0, view.frame.width / 3, (self.navigationController?.navigationBar.frame.height)!)
        timeLabel.textColor = UIColor.whiteColor()
        
        let logoImage = UIImageView()
        logoImage.frame = CGRectMake(0, 5, 64.4, (self.navigationController?.navigationBar.frame.height)! - 10)
        logoImage.image = UIImage(named: "Nav Logo")
        logoImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        navView.addSubview(timeLabel)
        navView.addSubview(logoImage)
        
        self.navigationItem.titleView = navView
        
        updateTime()
        var _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(self.moviePlayerVC.player?.rate == 0){
            //Dismissed
            self.moviePlayerVC.player = nil;
            
            blurRandomView.alpha = 0
            overlayView.alpha = 0

            blurRandomView.removeFromSuperview()
            
            lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            blurRandomView = UIVisualEffectView(effect: lightBlur)
            blurRandomView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            view.addSubview(blurRandomView)
            
            UIView.animateWithDuration(1, animations: {
                self.blurRandomView.alpha = 1
            })
            
            overlayView.frame = CGRectMake(120, 320, view.frame.width - 240, view.frame.height - 600)
            overlayView.backgroundColor = UIColor.whiteColor()
            
            let topLabel = UILabel()
            topLabel.frame = CGRectMake(10 , 0, overlayView.frame.width - 20, 40)
            topLabel.text = "What would you like the next show to do?"
            
            overlayView.addSubview(topLabel)
            
            let buttonOne = UIButton()
            buttonOne.setImage(UIImage(named: "Sad"), forState: UIControlState.Normal)
            buttonOne.frame = CGRectMake(10, 40, (overlayView.frame.width / 3) - 15, 135)
            buttonOne.backgroundColor = UIColorFromRGB(0xDDDDDD)
            buttonOne.addTarget(self, action: "buttonOneTapped", forControlEvents: UIControlEvents.TouchUpInside)
            
            overlayView.addSubview(buttonOne)
            
            let buttonTwo = UIButton()
            buttonTwo.setImage(UIImage(named: "Happy"), forState: UIControlState.Normal)
            buttonTwo.frame = CGRectMake(172.5, 40, (overlayView.frame.width / 3) - 15, 135)
            buttonTwo.backgroundColor = UIColorFromRGB(0xDDDDDD)
            buttonTwo.addTarget(self, action: "removeOverlays", forControlEvents: UIControlEvents.TouchUpInside)
            
            overlayView.addSubview(buttonTwo)
            
            let buttonThree = UIButton()
            buttonThree.setImage(UIImage(named: "Love"), forState: UIControlState.Normal)
            buttonThree.frame = CGRectMake(335, 40, (overlayView.frame.width / 3) - 15, 135)
            buttonThree.backgroundColor = UIColorFromRGB(0xDDDDDD)
            buttonTwo.addTarget(self, action: "removeOverlays", forControlEvents: UIControlEvents.TouchUpInside)
            
            overlayView.addSubview(buttonThree)
            
            let closeButton = UIButton()
            closeButton.setImage(UIImage(named: "Cross"), forState: UIControlState.Normal)
            closeButton.frame = CGRectMake(overlayView.frame.width - 30, 10, 20, 20)
            closeButton.addTarget(self, action: "removeOverlays", forControlEvents: UIControlEvents.TouchUpInside)
            
            overlayView.addSubview(closeButton)
            
            UIView.animateWithDuration(1, animations: {
                self.blurRandomView.alpha = 1
                self.overlayView.alpha = 1
            })
            
            blurRandomView.addSubview(overlayView)
            
            //performSegueWithIdentifier("showRateView", sender: self)
        }
    }
    
    func removeOverlays() {
        UIView.animateWithDuration(1, animations: {
            self.overlayView.alpha = 0
            self.blurRandomView.alpha = 0
        }, completion: { (finished:Bool) in
            self.blurRandomView.removeFromSuperview()
            self.overlayView.removeFromSuperview()
        })
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        DataManager.sharedInstance.apiRequest(self.locationManager!.location!.coordinate, callback: updateCollectionView)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if(newLocation.distanceFromLocation(oldLocation) > 500){
            DataManager.sharedInstance.apiRequest(self.locationManager!.location!.coordinate, callback: updateCollectionView)
        }
    }
    
    func updateCollectionView(succeeded: Bool, request: Dictionary<Emotion, [Media]>){
        self.media = request
        
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded();
        });
    }
    
    override func viewDidLayoutSubviews() {
        dispatch_async(dispatch_get_main_queue(), {
            var i = 0;
            for (keys, media) in self.media{
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 1)) as? ContentCell;
                
                if(cell != nil){
                    cell!.updateMedia(keys, media: media)
                    cell!.collectionView.reloadData();
                }
                i++;
            }
        });
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
        
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        let boldString = NSMutableAttributedString(string: timeOfDayString, attributes: attributes)
        
        attributedString.appendAttributedString(boldString)
        
        timeLabel.attributedText = attributedString
        
        //DataManager.sharedInstance.apiRequest(self.locationManager!.location!.coordinate, callback: updateCollectionView)
        self.navigationItem.titleView = navView
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
        }
        //var emotionCount: Int { return Emotion.Emotion.Cheeky.hashValue + 1}
        return self.media.keys.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resumeCell", forIndexPath: indexPath) as! ResumeCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentCell", forIndexPath: indexPath) as! ContentCell
            
            //cell.showImageView.image = media[indexPath.row].image
            //cell.showTitleLabel.text = media[indexPath.row].title
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let resumeWidth = floor(view.frame.width)
        //let contentWidth = floor(view.frame.width / 4)
        
        if indexPath.section == 0 {
            return CGSizeMake(resumeWidth - 10, 130)
        } else {
            return CGSizeMake(resumeWidth - 10, 120)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            do {
                try playVideo()
            } catch AppError.InvalidResource(let name, let type) {
                debugPrint("Could not find resource \(name).\(type)")
            } catch {
                debugPrint("Generic error")
            }
        }
    }
    
    private func playVideo() throws {
        guard let path = NSBundle.mainBundle().pathForResource("video", ofType: "mp4") else {
            throw AppError.InvalidResource("video", "mp4")
        }
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        self.moviePlayerVC.player = player
        self.presentViewController(self.moviePlayerVC, animated: true) {
            player.play()
        }
    }
    
    enum AppError: ErrorType {
        case InvalidResource(String, String)
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
