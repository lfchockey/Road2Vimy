//
//  TimelineView.swift
//  VimyRidgeApp
//
//  Created by MacBook on 2015-06-13.
//  Copyright (c) 2015 Matt Falkner. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TimelineView:UIViewController {
    
    
    var pins = [JSON]()
    
    let regionRadius: CLLocationDistance = 100000
    
    var pindex = 0
    var pin: MKAnnotation?
    
    @IBOutlet var Mapper: MKMapView!
    
    override func viewDidLoad() {
        println("You are now in the Timeline View")
    
    
        let url = "http://lest-we-forget.ca/apis/get_ww1_soldier_locations.php?access_code=SFDCI_Black&soldier_id=\(MyVariables.facebookSoldierID)"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"  // This defines how the information will be passed to the API website
        
        //self.Mapper.delegate = nil
        var response : NSURLResponse?
        var err : NSError?
        
        let locationData = JSON(data: NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &err)!)
        
        //locationData = JSON(globalSoldier.locationData)
        
        var zero: Int?
        
        pins = locationData.arrayValue
        
        if pins == []
        {
            zero = 0
            println("WINNER WINNER CHICKEN DINNER!")
        }
        
        changePin(pindex)
    }
    
    
    @IBAction func Previous(sender: AnyObject) {
        changePin(--pindex)
        print("Last Button")
        
    }
    @IBAction func Next(sender: AnyObject) {
        changePin(++pindex)
        print("Next Button")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        Mapper.setRegion(coordinateRegion, animated: true)
    }
    
    func changePin(newPindex: Int)
    {
        
        if pins.count == 0
        {
            return
        }
        
        
        pindex = newPindex
        
        if newPindex > (pins.count - 1)
        {
            pindex = 0
        }
        
        if newPindex < 0
        {
            pindex = (pins.count - 1)
        }
        
        
        
        let data = pins[pindex]
        
        let location = SoldierLocation(title: data["significance"].stringValue, address: data["location"].stringValue, coordinate: CLLocationCoordinate2D(latitude: data["latitude"].doubleValue, longitude: data["longitude"].doubleValue))
        
        Mapper.removeAnnotation(pin)
        Mapper.addAnnotation(location)
        
        pin = location
        
        Mapper.selectAnnotation(pin, animated: true)
        
        centerMapOnLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }

}