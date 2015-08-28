//
//  AlternateSearchPageController.swift
//  AppFiltersPage
//
//  Created by Student on 2015-06-16.
//  Copyright (c) 2015 Daniel. All rights reserved.
//

import UIKit

//Class used to control the initial setup page view for the search the user wishes to perform//
class SearchViewController: UIViewController
{
    //References to search switches and the known officer switch//
    @IBOutlet weak var soldierSearchSwitch: UISwitch!
    @IBOutlet weak var battalionSearchSwitch: UISwitch!
    @IBOutlet weak var locationSearchSwitch: UISwitch!
    @IBOutlet weak var knownOfficerSwitch: UISwitch!
    
    //References to the text fields for each search type//
    @IBOutlet weak var soldierNameTextField: UITextField!
    @IBOutlet weak var battalionNameTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    
    //References to the help button and the help text view//
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpTextView: UITextView!
    
    //Reference to the search button//
    @IBOutlet weak var searchButton: UIButton!
    
    //Sets the default search type to the soldier name...will be used when checking which URL to use//
    var searchType: String = "Soldier";
    
    //Array of what the user sets for the search...will be later sent to the NSUserDefaults and used by the sorter//
    //Name string, battalion string, location string, known officer bool, search type string
    var searchChoices: [AnyObject] = ["", "", "", true, ""];
    
    var allSoldiers: [JSON] = []; //Creates an array to contain the soldiers
    var totalSoldiers = 0; //Creates an int to represent the number of soldiers
    
    /*
        Connected to the three search type switches. Called any time any of them have their state changed.
        Depending on which one is calling this function, disables other text fields and turns off button.
        Also makes the text in the other boxes grayed out so it is easier to tell which field is enabled.
    */
    @IBAction func searchTypeChanged(sender: UISwitch)
    {
        if (sender.accessibilityLabel == "soldier") //Called when the soldier search switch is being changed
        {
            searchType = "Soldier"; //Sets the searchType variable back to soldier
            
            soldierNameTextField.enabled = true; //Enables text field for soldier and disables other two
            battalionNameTextField.enabled = false;
            locationNameTextField.enabled = false;
            
            soldierNameTextField.textColor = UIColor.blackColor(); //Sets the soldier field text to black
            battalionNameTextField.textColor = UIColor.grayColor(); //Sets other field's text to gray
            locationNameTextField.textColor = UIColor.grayColor();
            
            battalionSearchSwitch.setOn(false, animated: true); //Turns the other two search switches off
            locationSearchSwitch.setOn(false, animated: true);
            
            searchButton.enabled = true; //Enables the search button if it was off (only disabled if all off)
        }
        else if (sender.accessibilityLabel == "battalion") //Same as above for the battalion search
        {
            searchType = "Battalion";
            
            soldierNameTextField.enabled = false;
            battalionNameTextField.enabled = true;
            locationNameTextField.enabled = false;
            
            soldierNameTextField.textColor = UIColor.grayColor();
            battalionNameTextField.textColor = UIColor.blackColor();
            locationNameTextField.textColor = UIColor.grayColor();
            
            soldierSearchSwitch.setOn(false, animated: true);
            locationSearchSwitch.setOn(false, animated: true);
            
            searchButton.enabled = true;
        }
        else if (sender.accessibilityLabel == "location") //Same as above for the location search
        {
            searchType = "Location";
            
            soldierNameTextField.enabled = false;
            battalionNameTextField.enabled = false;
            locationNameTextField.enabled = true;
            
            soldierNameTextField.textColor = UIColor.grayColor();
            battalionNameTextField.textColor = UIColor.grayColor();
            locationNameTextField.textColor = UIColor.blackColor();
            
            soldierSearchSwitch.setOn(false, animated: true);
            battalionSearchSwitch.setOn(false, animated: true);
            
            searchButton.enabled = true;
        }
        
        if (sender.on == false) //Checks if all three switches are off
        {
            soldierNameTextField.enabled = false; //Disablestext fields (only needs to disable one but checks all)
            battalionNameTextField.enabled = false;
            locationNameTextField.enabled = false;
            searchButton.enabled = false; //Disables search button to prevent searching without type chosen
        }
    }
    
    /*
        Called whenever the user touches the search button. 
        The search button also has an action outlet causing the view to shift to the results page instead (not here)
        Mainly just saves the user's choices and text entries to the standard defaults to be accessed by next view.
    */
    @IBAction func searchButtonHit(sender: UIButton)
    {
        let defaults = NSUserDefaults.standardUserDefaults(); //Creates object to access standardUserDefaults
        
        searchChoices[0] = soldierNameTextField.text; //Saves the three strings entered in the text fields
        searchChoices[1] = battalionNameTextField.text;
        searchChoices[2] = locationNameTextField.text;
        searchChoices[3] = knownOfficerSwitch.on; //Saves if the user set the known officer switch to on
        searchChoices[4] = searchType; //Saves the type of search as a string (like above)
        
        defaults.setValue(searchChoices, forKey: "SearchChoices"); //Saves all above values
    }
    
    /*
        Called whenever the user touches the show help button.
        Note: Hides and unhides the search button because it would show through the text and could be clicked.
    */
    @IBAction func helpButtonToggled(sender: UIButton)
    {
        if (helpTextView.hidden == true) //Checks if the help view is currently hidden
        {
            helpTextView.hidden = false; //If it is, shows the view and hides search button...
            searchButton.hidden = true; //...had to add this because search button would show through help page
        }
        else //Inverse of above
        {
            helpTextView.hidden = true;
            searchButton.hidden = false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battalionNameTextField.enabled = false; //Defaults battalion and location text fields to off
        locationNameTextField.enabled = false;
        
        battalionNameTextField.textColor = UIColor.grayColor(); //Defaults above fields' text to gray
        locationNameTextField.textColor = UIColor.grayColor();
        
        helpTextView.hidden = true; //Hides the help text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
