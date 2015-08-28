//
//  Medals.swift
//  VimyRidgeApp
//
//  Created by Matthew Falkner on 2015-06-21.
//  Copyright (c) 2015 Matt Falkner. All rights reserved.
//

import Foundation
import UIKit

class Medals:UIViewController, UITableViewDataSource, UITableViewDelegate {

    var totalAwards = 0
    var allAwards = [JSON]()
    
    @IBOutlet weak var awardTableView: UITableView!
    
    @IBOutlet weak var Selector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("You are in the Medals view")
        
        awardTableView!.delegate = self
        awardTableView!.dataSource = self
        
        
        // The following code connects to the lwf.ca database/server and retrieves all of the awards for a soldier, storing them in an array
        var url : String = "http://lest-we-forget.ca/apis/search2.php?action=search_awards&access_code=SFDCI_Black&soldier_id=\(MyVariables.facebookSoldierID)"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var response : NSURLResponse?
        var err : NSError?
        
        var awardArray = JSON([])
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &err)
        
        if data != nil {
            awardArray = JSON(data: data!)
            totalAwards = awardArray.count
        }
        
        allAwards = awardArray.arrayValue
        //println(allAwards)
        
        awardTableView!.reloadData()

    }
    
       
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalAwards
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let award = allAwards[indexPath.row]
        
        cell.textLabel?.text = award.stringValue //["name"].stringValue
        
        
        // *** The following code attempts to place images of each medal/award in the table view cell
        //      These images need to be created first and placed in the Images.xcassets
        /* switch award
        {
            
        case "1914 - 1915 Star":
            var image : UIImage = UIImage(named: "1914 1915 star")!
            cell.imageView?.image = image
            
        case "British War Medal":
            var image : UIImage = UIImage(named: "British war medal")!
            cell.imageView?.image = image
            
        default:
            var image : UIImage = UIImage(named: "else")!
            cell.imageView?.image = image
        }
        */
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}