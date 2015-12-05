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
    class var sharedInstance: DataManager {
        struct Static {
            static let instance: DataManager = DataManager()
        }
        return Static.instance
    }

    func apiRequest(location: CLLocationCoordinate2D, callback: (succeeded: Bool, request: [Media]) -> ()){
        let defaults = NSUserDefaults.standardUserDefaults();
        let subscriberId = defaults.objectForKey("subscriberId") as! String;
        let deviceId = defaults.objectForKey("deviceId") as! String;
        let locationString = String(format: "%f;%f", location.latitude, location.longitude);
        
        let params = ["location":locationString, "deviceId":deviceId, "subscriberId":subscriberId] as Dictionary<String, String>
        
        post(params, url: "http://localhost:8080/api/", postCompleted: callback)
    }
    
    private func post(params : Dictionary<String, String>, url : String, postCompleted : (succeeded: Bool, request: [Media]) -> ()) {
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
                    postCompleted(succeeded: false, request: [])
                    return;
                }
                
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    postCompleted(succeeded: true, request: self.jsonToObjects(parseJSON))
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
            postCompleted(succeeded: false, request: [])
        }
        
        
    }
    
    func jsonToObjects(json: NSDictionary) -> [Media]{
        let jsonArray = json["recommendations"] as! [NSDictionary];
        var mediaArray: [Media] = [];
        
        for(var i = 0; i < jsonArray.count; i++){
            let mediaDict: NSDictionary = jsonArray[i];
            //mediaDict[i]["genre"]
            let programmeId = mediaDict["programmeId"] as! String;
            let url = NSURL(string: "http://localhost:8080/images/" + programmeId + ".jpeg");
            let media: Media = Media(title: mediaDict["name"] as? String, duration: 0, genre: Media.Genre.Kids, subGenre: "", channel: "", image: url);
            mediaArray.append(media);
        }
        
        return mediaArray;
    }
}
