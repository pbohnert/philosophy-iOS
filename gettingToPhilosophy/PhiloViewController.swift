//
//  PhiloViewController.swift
//  gettingToPhilosophy
//
//  Created by Peter Bohnert on 6/24/16.
//  Copyright © 2016 bluelotuslabs.co. All rights reserved.
//

import UIKit
import Alamofire

class PhiloViewController: UIViewController, UITextFieldDelegate {
    var inputURL:String!
    var completePath:String!
    var numHops:String!
    var navTitle = "Getting to Philosophy"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var pathDisplay: UITextView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.inputText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationItem.title = self.navTitle
        //self.messageLabel.text = ""
        self.titleLabel.text = "Enter a subject to start with:"
        // self.messageLabel.text = "Please enter a valid Wikipedia URL"
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(inputText: UITextField!) -> Bool {
        
        self.inputURL = inputText.text
        
        //textField.resignFirstResponder()  //if desired
        findPhilo()
        return true
    }
    
    func findPhilo() {
        self.messageLabel.text = ""
            
        // let's go see if we can find Philosophy
         searchWithURL { (success, error) -> () in
                if success != "Success" {
                    self.messageLabel.text = "Philosophy not found this time."
                }
                else  {
                    self.messageLabel.text = "Philosophy found!  Number of hops was" + self.numHops
                }
                print("just back from send Code")
            }
    }

    @IBAction func textEdited(sender: AnyObject) {
        self.messageLabel.text = ""
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
    
    func searchWithURL(completionHandler: (String?, NSError?) -> ()) -> () {
        
        //var myJSON:JSON!
        let myURL = myVariables.myURL + "/search"
        var success:String = "success"
        print("my url string is: \(myURL)")
        
        
        showLoadingProgress()
        //test code for checking return JSON as a string
        /*Alamofire.request(.GET, myVariables.myURL + "/search", parameters:  ["url": self.inputURL]).responseString { p, s, r in print(p, s, r) } */
        
        Alamofire.request(.GET, myURL, parameters: ["url": self.inputURL]).responseJSON() { (_, _, JSON) in
            print(JSON.value)  //returns an array of NSDictionary
            
            if let top = JSON.value as? NSDictionary {
                print("top equals \(top)")
                self.pathDisplay.text = top["body"] as? String
                self.numHops = top["hops"] as? String
                
            } else {
                success = "no success"
            }
            
            // Hide the progress indicator
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.navigationItem.title = self.navTitle
            completionHandler(success, nil)
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
