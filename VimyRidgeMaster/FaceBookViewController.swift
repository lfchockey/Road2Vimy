//
//  ViewController.swift
//  VimyRidgeApp
//
//  Created by MacBook on 2015-06-13.
//  Copyright (c) 2015 Matt Falkner. All rights reserved.
//

import UIKit

struct MyVariables {
    static var globalSoldier:FullSoldier = FullSoldier()
    static var access_code: String = "SFDCI_Black"
    static var set:Bool = false
    static var facebookSoldierID: String = ""
}

class FaceBookViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func SwapViews(sender: AnyObject) {
        moveViews(sender.selectedSegmentIndex)
    }
   
    func grabDataOnSoldier() {
        //var url : String = "http://lest-we-forget.ca/apis/redirect_ww1_mobile.php?type=add_soldier&access_code=\(MyVariables.access_code)&officer=yes&rank=Major&surname=Hayes&christian_names=ThomasJared&soldier_id=25"
        var url : String = "http://lest-we-forget.ca/apis/get_ww1_soldier_api.php?access_code=\(MyVariables.access_code)&soldier_id=\(MyVariables.facebookSoldierID)"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            

            if (jsonResult != nil) {
                
                dispatch_async(dispatch_get_main_queue())
                {
                        MyVariables.globalSoldier = MyVariables.globalSoldier.assignSoldier(jsonResult)
                        //print(MyVariables.globalSoldier.battalion)
                        MyVariables.set = true
                        self.moveViews(0)
                        self.indicator.hidden = true
                }
            }
            
        })

    }
    
    
    func moveViews(sender:Int) {
        let viewControllerIdentifiers = ["Profile", "Biography", "Friends", "Timeline", "Photos","Medals"]
        var newController = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[sender]) as! UIViewController
        let oldController = childViewControllers.last as! UIViewController
        
        oldController.willMoveToParentViewController(nil)
        addChildViewController(newController)
        newController.view.frame = oldController.view.frame
        transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
            }, completion: { (finished) -> Void in
                oldController.removeFromParentViewController()
                newController.didMoveToParentViewController(self)
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("What's my number \(MyVariables.facebookSoldierID)?")
        grabDataOnSoldier()
        moveViews(0)
        indicator.hidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

