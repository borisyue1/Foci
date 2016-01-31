//
//  post.swift
//  lah2
//
//  Created by Shivam Dave on 1/31/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import Parse

class post: UIViewController {
    
    
 
    @IBOutlet var rate: rating!
 
  
    @IBOutlet var address: UILabel!
    
    
    @IBOutlet var comments: UITextField!
    
    
    @IBAction func post(sender: AnyObject) {
        
        
        
        
        
        
        
        
    }

    @IBAction func publish(sender: AnyObject) {
        
        var post = PFObject(className: "Post")
        post["review"] = comments.text
        post["userId"] = PFUser.currentUser()?.objectId
        post["location"] = address.text
        let imageData = UIImagePNGRepresentation(convert())
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                
                print("success")
                
                self.displayAlert("Success!", message: "Your review was posted")
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

    
    
   
    
    func convert()-> UIImage {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        self.rate.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return screenShot
        
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let addressAccess = ViewController()
        print(addressAccess.getAddress())
        address.text = ViewController.address
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
     
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
