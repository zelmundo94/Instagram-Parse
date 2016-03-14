//
//  HomeViewController.swift
//  Instagram
//
//  Created by Denzel Ketter on 3/7/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var instagramPosts: [PFObject]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 370
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        // Refresh posts from Parse each time the user visits this view controller since new posts
        // might have been added in PhotoCaptureViewController. An alternative would be to use
        // NSNotificationCenter or a subclass of UITabBarController to communicate between view
        // controllers when a new post is added, but this might be too much to go over in this
        // assignment.
        self.getInstagramPostsFromParse()
    }

    func getInstagramPostsFromParse() {
        print("Retrieving Instagram Posts from Parse...")
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("photo")
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let results = results {
                    print("Successfully retrieved \(results.count) posts")
                    self.instagramPosts = results
                    self.tableView.reloadData()
                } else {
                    print("No results returned")
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 10
        return self.instagramPosts == nil ? 0 : self.instagramPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotosCellTableViewCell
        cell.instagramPost = instagramPosts[indexPath.row]
        return cell
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
