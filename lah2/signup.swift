//
//  signup.swift
//  lah2
//
//  Created by Shivam Dave on 1/30/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import Parse

class signup: UIViewController {
    
    
    @IBOutlet var firstname: UITextField!
    
    
    @IBOutlet var lastname: UITextField!
    
    
    @IBOutlet var username: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    
    
    
    @IBAction func signup(sender: AnyObject) {
        
        
        if firstname.text == "" || lastname.text == "" || username.text == "" || password.text == "" {
            
                        displayAlert("Error in form", message: "Please enter a name, username, and password")
                    }
        
        else{
            
            activity = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activity.center = self.view.center
            
            activity.hidesWhenStopped = true
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activity)
            activity.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var user = PFUser()
            
            user.username = username.text
            user.password = password.text
            
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock {
                (success, error) -> Void in
                self.activity.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                if error == nil {
                    
                    
                }
                
                else{
                    
                    if let errorString = error!.userInfo["error"] as? NSString {
                        
                        errorMessage = errorString as String
                        
                    }
                    
                    self.displayAlert("Failed Signup", message: errorMessage)
                }
                
                
            }
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func displayAlert(title: String, message: String){
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
