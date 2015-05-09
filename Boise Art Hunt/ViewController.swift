//
//  ViewController.swift
//  Boise Art Hunt
//
//  Created by Daniel Ryan on 5/9/15.
//  Copyright (c) 2015 Daniel Ryan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var latitude:CLLocationDegrees = 43.6167
        var longitude:CLLocationDegrees = -116.2000
        var latDelta:CLLocationDegrees = 0.1
        var longDelta:CLLocationDegrees = 0.1
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        myMap.setRegion(region, animated: true)
        
        getArt()
        
    }
    
    func action(gestureRecognizer:UIGestureRecognizer)
    {
        
        var touchPoint = gestureRecognizer.locationInView(self.myMap)
        
        var newCoordinate: CLLocationCoordinate2D = self.myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "New"
        
        annotation.subtitle = "the subtitle"
        
        self.myMap.addAnnotation(annotation)
    }
    
    func getArt()
    {
        var urlString = "http://www.boisearthunt.com/data/boiseartshistory.json"
        var url = NSURL(string: urlString)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error)
            in
            // we serialize our bytes back to the original JSON structure
            let jsonResult: Dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! Dictionary<String, AnyObject>
            
            // we grab the colorsArray element
            let results: NSArray = jsonResult["features"] as! NSArray
            
            // we iterate over each element of the colorsArray array
            for item in results {
                
                // we convert each key to a String
                var record: NSDictionary = item["attributes"] as! NSDictionary
                var latitude: CLLocationDegrees = (record["Latitude"] as! NSString).doubleValue
                var longitude: CLLocationDegrees = (record["Longitude"] as! NSString).doubleValue
                
                var newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                
                dispatch_async(dispatch_get_main_queue()) { // Should ALWAYS update UI on main queue, otherwise UI changes take forever
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = record["Title"] as! String
                    
                    annotation.subtitle = record["ArtistMaker"] as! String
                    
                    self.myMap.addAnnotation(annotation)
                    
                }
                
            }        }
        
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

