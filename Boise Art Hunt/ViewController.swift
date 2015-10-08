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
        
        
        let latitude:CLLocationDegrees = 43.6167
        let longitude:CLLocationDegrees = -116.2000
        let latDelta:CLLocationDegrees = 0.1
        let longDelta:CLLocationDegrees = 0.1
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        myMap.setRegion(region, animated: true)
        
        getArt()
        
    }
    
    func action(gestureRecognizer:UIGestureRecognizer)
    {
        
        let touchPoint = gestureRecognizer.locationInView(self.myMap)
        
        let newCoordinate: CLLocationCoordinate2D = self.myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
        let annotation = MKPointAnnotation()
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
            let jsonResult: Dictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! Dictionary<String, AnyObject>
            
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

