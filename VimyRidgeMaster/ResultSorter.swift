//
//  ResultSorter.swift
//  AppFiltersPage
//
//  Created by Student on 2015-06-13.
//  Copyright (c) 2015 Daniel. All rights reserved.
//

import Foundation 

/*
    Class used in order to sort the results the user gets from the search.
    Currently only sorts officers if the user selected it.
    **** Add check for all unique ID's in case of duplicates****
*/
class ResultSorter
{
    //Function that actually does the sorting. Requires a JSON array and returns the sorted array.
    //Purpose built just for this app search feature.
    func sortResults(resultsToSort: [JSON]) -> [JSON]
    {
        //Creates a NSUserDefaults object which allows the app to access stored values between classes and instances and also after the app is closed. Will be used to get the strings the user entered into the search bars.
        let defaults = NSUserDefaults.standardUserDefaults();
        
        var sortedResults: [JSON] = resultsToSort; //Creates a duplicate array to be sorted
        var filterSettings = defaults.valueForKey("SearchChoices") as! NSArray; //Gets user's search terms
        var numSoldiersRemoved = 0; //Will be used to prevent array from going out of range when removing soldiers
        
        if (filterSettings[3] as! Bool == true) //Checks if the user set the known officer switch to on
        {
            for (var i = 0; i < resultsToSort.count; i++) //Cycles through every soldier in the array
            {
                let soldierBeingChecked = resultsToSort[i]; //Sets the soldier to a constant to be accessed easier
                let soldierID = soldierBeingChecked["soldier_id"].stringValue; //Gets the soldier's ID
                let soldierIDRequirement = "999"; //Officer ID's start with 999...will be used to check if officer
                
                //Checks if there is a 999 in the id of the soldier...will run if there is not (ie: not officer)
                if (soldierID.rangeOfString(soldierIDRequirement) == nil)
                {
                    sortedResults.removeAtIndex(i - numSoldiersRemoved); //Removes the soldier from the sorted array
                    numSoldiersRemoved++; //Increments variable...prevents array index out of range error
                }
            }

        }
        //sortedResults = checkForDuplicates(sortedResults);
        return sortedResults; //Returns the array of the sorted results
    }
    
    /*func checkForDuplicates(resultsToSort: [JSON]) -> [JSON]
    {
        var sortedResults: [JSON] = resultsToSort;
        var numberOfSoldiersRemoved = 0;
        
        for (var i = 0; i < resultsToSort.count; i++)
        {
            let soldierBeingChecked = sortedResults[i];
            
            for (var j = 0; j < resultsToSort.count; j++)
            {
                let soldierBeingCheckAgainst = sortedResults[j];
                
                if (j != i) //Makes sure the soldier isn't being checked against itself
                {
                   if (soldierBeingChecked["soldier_id"].stringValue == soldierBeingChecked["soldier_id"].stringValue)
                   {
                        sortedResults.removeAtIndex(j - numberOfSoldiersRemoved);
                        numberOfSoldiersRemoved++;
                   }
                }
            }
        }
        
        return sortedResults;
    }*/
}





