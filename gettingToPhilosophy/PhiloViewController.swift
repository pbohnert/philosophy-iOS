//
//  PhiloViewController.swift
//  gettingToPhilosophy
//
//  Created by Peter Bohnert on 6/24/16.
//  Copyright © 2016 bluelotuslabs.co. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PhiloViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoadingProgress() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDMode.Indeterminate
        loading.labelText = "Finding Philosophy...";
    }
    
    func loginToDymeAccount(completionHandler: (String?, NSError?) -> ()) -> () {

        
        showLoadingProgress()
        self.errorState = ""
        
        Alamofire.request(.POST, myVariables.myURL + "/user/login", parameters: ["username": emailText.text!]).responseJSON() { (_, _, JSON) in
            print(JSON)
            print(JSON.value)
            if let top = JSON.value as? NSMutableDictionary {
                if let ourAcct = top["account"] as? NSMutableDictionary {
                    self.accountDict = ourAcct
                    if let idString = ourAcct["_id"] {
                        dymeUserid = idString as! String
                    }
                    if  let phoneDeets = ourAcct["phone_details"] {
                        if let phoneVerified = phoneDeets["is_verified"] as? Bool {
                            if !phoneVerified {
                                self.segueName = self.notVerified
                            } // end of check on verified bool
                        } // end of get is verified flag
                        
                    }
                } // end of if we can grab our account
                
                if let whatState = top["missing"] as? String {
                    if self.segueName != self.notVerified {
                        self.segueName = whatState
                    }
                } // end of if has_completed
                
                if let err = top["error"] as? String {
                    self.errorState = err
                    if err.hasPrefix("No Account Found") {
                        self.messageLabel.text = self.notDefinedYet
                        dymeUserid = self.notDefinedYet
                    }
                    else if err.hasPrefix("Invalid Password") {
                        self.messageLabel.text = "Oops.  We didn't recognize that password"
                    }
                } // end if let err
            } // end of if let JSON.value
            
            // Hide the progress indicator
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.navigationItem.title = "Login"
            completionHandler(dymeUserid, nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
