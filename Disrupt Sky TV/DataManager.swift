//
//  DataManager.swift
//  Disrupt Sky TV
//
//  Created by Oliver on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit
import MapKit

class DataManager: NSObject {
    var baseUrl = "http://localhost:8080/";
    
    class var sharedInstance: DataManager {
        struct Static {
            static var instance: DataManager = DataManager()
        }
        return Static.instance
    }

    func apiRequest(location: CLLocationCoordinate2D, time: NSDate, callback: (Bool, Dictionary<Emotion, [Media]>) -> ()){
        let defaults = NSUserDefaults.standardUserDefaults();
        let subscriberId = defaults.objectForKey("subscriberId") as! String;
        let deviceId = defaults.objectForKey("deviceId") as! String;
        let locationString = String(format: "%f;%f", location.latitude, location.longitude);
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        let timeString = dateFormatter.stringFromDate(time);
        
        let params = ["time": timeString, "location":locationString, "deviceId":deviceId, "subscriberId":subscriberId] as Dictionary<String, String>
        print(params);
        post(params, url: self.baseUrl + "api/", postCompleted: callback)
    }
    
    private func post(params : Dictionary<String, String>, url : String, postCompleted: (Bool, Dictionary<Emotion, [Media]>) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: []);
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //print("Body: \(strData)")
                
                var json: NSDictionary?;
                do{
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                }catch{
                    postCompleted(false, Dictionary<Emotion, [Media]>())
                    return;
                }
                
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    let message = parseJSON["message"] as? String;
                    postCompleted((message == nil), self.jsonToObjects(parseJSON))
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            })
            task.resume()
        }catch{
            postCompleted(false, Dictionary<Emotion, [Media]>())
        }
        
        
    }
    
    func jsonToObjects(json: NSDictionary) -> Dictionary<Emotion, [Media]>{
        let emotions = ["positive", "negative", "neutral"];
        var emotionsArray = Dictionary<Emotion, [Media]>();
        for(var j = 0; j < emotions.count; j++){
            let jsonArray = json[emotions[j]] as! [NSDictionary];
            var mediaArray: [Media] = [];
            for(var i = 0; i < jsonArray.count; i++){
                var mediaDict: NSDictionary = jsonArray[i];
                //mediaDict[i]["genre"]
                let programmeId = mediaDict["programmeId"] as! String;
                let url = NSURL(string: self.baseUrl + "images/" + programmeId + ".jpeg");
                let media: Media = Media(title: mediaDict["name"] as? String, duration: 0, genre: Media.Genre.Kids, subGenre: "", channel: "", image: url);
                mediaArray.append(media);
            }
            
            var emotionKey: Emotion;
            
            switch emotions[j]{
            case "positive":
                emotionKey = Emotion.Happy;
            case "negative":
                emotionKey = Emotion.Sad;
            default:
                emotionKey = Emotion.KeepVibe;
            }
            emotionsArray[emotionKey] = mediaArray;
        }
        return emotionsArray;
    }
}
