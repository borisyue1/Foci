//
//  login.swift
//  lah2
//
//  Created by Shivam Dave on 1/30/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import Parse

class login: UIViewController {
    
    
    @IBOutlet var username: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    var errorMessage = "Please try again later"
    
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    

    
    
    @IBAction func login(sender: AnyObject) {
        
        
        if  username.text == "" || password.text == "" {
            
            displayAlert("Error in form", message: "Please enter a name, username, and password")
        }
        
        else {
            
            activity = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activity.center = self.view.center
            
            activity.hidesWhenStopped = true
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activity)
            activity.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        
        PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            self.activity.stopAnimating()
            if user != nil {
                // Do stuff after successful login.
                
               // var nextViewController = ViewController()
               // self.presentViewController(nextViewController, animated: true, completion: nil)
                
                self.performSegueWithIdentifier("login", sender: sender)
      
                

                
                
            } else {
                // The login failed. Check error to see why.
                
                
                if let errorString = error!.userInfo["error"] as? NSString {
                    
                    self.errorMessage = errorString as String
                }
                
                self.displayAlert("Failed login", message: self.errorMessage)
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("superView")
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
