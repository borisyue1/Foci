//
//  table.swift
//  lah2
//
//  Created by Shivam Dave on 1/31/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var usernames = [""]
    var userids = [""]
    
    //use bool because the user is either following or isnt
    
    //since we emptied all arrays this one must be emptied as well but must have a value beforehand
    //store the userid in the blank
    var isFollowing = ["": false]
    
    var refresher: UIRefreshControl!
    
    func refresh(){
        
        var query = PFUser.query()
        query? .findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            //check if objects exist
            if  let users = objects {
                
                //how to clear an array
                
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                
                
                //if that happpens we can use users as our anyobject to loop thru to get any of our usernames
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        //this only lists the users besides the active user
                        if user.objectId! != PFUser.currentUser()?.objectId {
                            
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            
                            //check whether users are being followed by current user
                            //create a query on followers class
                            var query = PFQuery(className: "followers")
                            
                            //add 2 wherekeys, we want follower to be equal to the current user
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            
                            //we want the person that they are following's object id to be equal user id
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            
                            //run the query
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                //check whether object is nil or not
                                //if objects = objects the user must be following the other user
                                //if its returned with the 2 wherekeys the following must be active, store it in array
                                if let objects = objects {
                                    
                                    if objects.count > 0{
                                        
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                        
                                    }
                                        
                                    else {
                                        
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                //essentially will only update when we got same number of usernames is  the same as isfollowing
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    //need to remove the pull to refresh symbol after refresh is complete
                                    
                                    self.refresher.endRefreshing()
                                }
                            })
                            
                            
                        }
                    }
                }
            }
            
            
            print(self.usernames)
            print(self.userids)
            
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refresher = UIRefreshControl()
        
        //add title to refresher, string is whatever u want to appear and will appear when users starts to pull
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        
        //we run the refresh function when the value has changed (ie when table is pulled down)
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        //created a variable equal to userid just tapped on
        //and then worked out to see whether user is following that user
        let followedObjectId = userids[indexPath.row]
        
        if isFollowing[followedObjectId] == true {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        return cell
    }
    
    //this will happen when a user taps on a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let followedObjectId = userids[indexPath.row]
        
        if  isFollowing[followedObjectId] == false {
            
            
            
            isFollowing[followedObjectId] == true
            //this places a checkmark at
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            
            var following =  PFObject(className: "followers")
            
            //each object in our class has following and follower
            //following is going to be id of user that has just been tapped on
            //the id of the user that has just tapped on (ie the one that our user wants to follow
            following["following"] = userids[indexPath.row]
            //with follower its the id of the current user
            following["follower"] = PFUser.currentUser()?.objectId
            
            
            following.saveInBackground()
            
        }
            
        else {
            
            isFollowing[followedObjectId] == false
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            
            var query = PFQuery(className: "followers")
            
            
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            
            //we get following from the usersids
            //we want the id of the user we just tapped on
            
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            
            
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                
                if let objects = objects {
                    
                    //we will loop thru and delete all of the users being tapped on
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                        
                    }
                }
                
                
            })
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
}
