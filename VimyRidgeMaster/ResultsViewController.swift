//
//  AlternateResultsPageController.swift
//  AppFiltersPage
//
//  Created by Student on 2015-06-16.
//  Copyright (c) 2015 Daniel. All rights reserved.
//

import UIKit

//Class used to control the view that shows the results of the search//
class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var soldierTableView: UITableView! //Reference to the results table view
    
    var totalSoldiers = 0; //Int for number of soldiers sent back from database
    var totalSoldiersSorted = 0; //Int for number of soldiers after sorted
    
    var allSoldiers: [JSON] = []; //Array for soldiers sent back from database
    var allSoldiersSorted: [JSON] = []; //Array for soldiers after sorted
    
    //Called when setting up the table view to determine the number of rows//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return totalSoldiersSorted; //Sends back the number of soldiers after being sorted
    }
    
    //Called when setting up the table view to add the text for each cell//
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let rowIdentifier = "reuseIdentifier" //Creates the row id
        var cell = tableView.dequeueReusableCellWithIdentifier(rowIdentifier) as? UITableViewCell //Gets the cell
        
        if let tempo1 = cell
        {
            let index = indexPath.row as Int //Gets the index for the cell being done at that time
            
            //Creates the label for the cell by putting together the soldier's name, ID number, and town
            let cellTextLabel1 = allSoldiersSorted[index]["name"].stringValue;
            let cellTextLabel2 = allSoldiersSorted[index]["soldier_id"].stringValue;
            let cellTextLabel3 = allSoldiersSorted[index]["place_of_enlistment"].stringValue;
            
            //Creates the final label by putting together the above sections
            let cellTextLabelFinal = "\(cellTextLabel1) - \(cellTextLabel2) - \(cellTextLabel3)";
            
            //Sets the label on the cell to be the final label from above
            cell!.textLabel!.text = cellTextLabelFinal;
        }
        else
        {
            //Creates a default cell
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: rowIdentifier)
        }
        return cell! //Returns the cell
    }
    
    //Called whenever the user selects one of the cells//
    /*
        Currently has basically no effect. Code to transition to the soldier's profile should go here!
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)! //Gets the selected cell
        
        // The following code segues to the Facebook View Controller once a soldier has been selected
        let index = indexPath.row as Int //Gets the index for the cell being done at that time
        MyVariables.facebookSoldierID = allSoldiersSorted[index]["soldier_id"].stringValue
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("FacebookSegue", sender: self)
        }
        //println("User Selected: \(selectedCell.textLabel!.text)"); //Currently just displays the text to the log
    }
    
    /*
        Custom function that is used to perform the search.
        Forms the URL based on the user's desired search, sends request, gets results.
        Sends the results to be sorted and then finally displays them.
    */
    func search()
    {
        let defaults = NSUserDefaults.standardUserDefaults(); //Creates object to access user defaults
        let searchChoices = defaults.valueForKey("SearchChoices") as! NSArray; //Gets the user's search terms
        let searchType = searchChoices[4] as! String; //Gets the search type string to be checked next
        
        var url: String = ""; //Creates the string to hold the URL for the webpage getting connected to
        
        if (searchType == "Soldier") //Checks if the user chose to search by the soldier's name
        {
            //Stores the soldier name typed into the textField as a variable
            var soldier_Name = searchChoices[0] as! String;
            
            //Creates the url to connect to the soldier search
            url = "http://lest-we-forget.ca/apis/ww1_search.php?access_code=SFDCI_Black&action=search_name&name=\(soldier_Name)";
        }
        else if (searchType == "Battalion") //Same as above for battalion
        {
            var battalion_Name = searchChoices[1] as! String;
            url = "http://lest-we-forget.ca/apis/ww1_search.php?access_code=SFDCI_Black&action=search_battalion&battalion=\(battalion_Name)";
        }
        else if (searchType == "Location") //Same as above for location
        {
            var location_Name = searchChoices[2] as! String;
            url = "http://lest-we-forget.ca/apis/ww1_search.php?access_code=SFDCI_Black&action=search_place&place=\(location_Name)";
        }

        // This takes into consideration when someone puts multiple names with spaces in the URL
        var escapedAddress = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        // Build the URL request with the URL above
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: escapedAddress!)
        request.HTTPMethod = "GET"  // This defines how the information will be passed to the API website
        
        
        var response : NSURLResponse?
        var err : NSError?
        
        var soldierArray = JSON([])
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &err)
        
        //let jsn: NSDictionary = data as NSDictionary
        if data != nil {
            soldierArray = JSON(data: data!)
            totalSoldiers = soldierArray.count
            
            //DEBUG//
            //println(soldierArray) // print to see the data that was passed back from the server
        }
        else {
            // *** place an appropriate error message popup here if something went wrong
            println(response)
            println(err)
        }
        
        
        allSoldiers = soldierArray.arrayValue // This creates an array of all the soldiers sent back
        
        soldierTableView!.delegate = self //Sets this class to be able to control the table view
        soldierTableView!.dataSource = self
        
        allSoldiersSorted = ResultSorter().sortResults(allSoldiers); //Sends the returned results to be sorted
        totalSoldiersSorted = allSoldiersSorted.count; //Sets the number of sorted soldiers to new amount
        
        //DEBUG//
        println(allSoldiersSorted); //prints out the whole array of sorted soldiers
        println("Unsorted Count \(allSoldiers.count)"); //prints out the number before being sorted
        println("Sorted Count \(allSoldiersSorted.count)") //prints out the number after being sorted
        
        self.soldierTableView.reloadData(); //Reloads the data in the table
        
        //Causes the search results to be loaded immediately into the table
        //Without this, the table is not updated immediately and has to be scrolled randomly until results appear
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.soldierTableView.reloadData()
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        soldierTableView.delegate = self; //Allows this class to control the table view
        soldierTableView.dataSource = self;
        soldierTableView.scrollEnabled = true; //Allows for scrolling within the table view
        search(); //Calls the search function in order to get the results
        soldierTableView.reloadData(); //Reloads the table one last time to be sure
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
