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
    var ourURL:String!
    var completePath:String!
    var navTitle = "Getting to Philosophy"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var pathDisplay: UITextView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationItem.title = self.navTitle
        self.messageLabel.text = ""
        self.titleLabel.text = "Enter a Wikipedia URL:"
        // self.messageLabel.text = "Please enter a valid Wikipedia URL"
        
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
        
        let url = "www.wikipedia.org"
        var myJSON:JSON!
        
        showLoadingProgress()

        Alamofire.request(.POST, myVariables.myURL + "/search?JSON=1", parameters:  ["url": url]).responseJSON { response in
            
            guard let data = response.result.value else{
                print("Request failed with error")
                return
            }
            
            myJSON = JSON(data)
            
                    print("myJSON equals \(myJSON)")
                 /*   if let myString = top["Message"] as? String {
                        if myString.hasPrefix("Success") {
                            // do something here
                        }
                    } */
                    
                    
            
            // Hide the progress indicator
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.navigationItem.title = "Login"
            completionHandler("complete", nil)
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
