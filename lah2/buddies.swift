//
//  buddies.swift
//  lah2
//
//  Created by Shivam Dave on 1/31/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import Parse

class buddies: UITableViewController {
    
    var usernames = [""]
    var userids = [""]
    var isFollowing = ["":false]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId! != PFUser.currentUser()?.objectId{
                        self.usernames.append(user.username!)
                        self.userids.append(user.objectId!)
                            
                            var query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                if let objects = objects{
                                    
                                    
                                    if objects.count > 0{
                                    self.isFollowing[user.objectId!] = true
                                    }
                                    
                                
                                else{
                                    
                                    self.isFollowing[user.objectId!] = false
                                }
                                
                                if self.isFollowing.count == self.usernames.count{
                                
                                self.tableView.reloadData()
                                    
                                }
                                }
                            })
                            
                        }
                    }
                }
            }
            
          
            
            
            self.tableView.reloadData()
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usernames[indexPath.row]
        let followedObjectId = userids[indexPath.row]
        if isFollowing[followedObjectId] == true{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
         let followedObjectId = userids[indexPath.row]
        
        if isFollowing[followedObjectId] == false{
            
            isFollowing[followedObjectId] = true
     
        
        
        
        print(indexPath.row)
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        
        
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        var following = PFObject(className: "followers")
        following["following"] = userids[indexPath.row]
        following["follower"] = PFUser.currentUser()?.objectId
        
        following.saveInBackground()
            
        }
        
        else{
            
            isFollowing[followedObjectId] == false
          
            
            var query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects{
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                    }
                    
                if self.isFollowing.count == self.usernames.count{
                    
                    self.tableView.reloadData()
                    
                }
                }
            })
            
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
