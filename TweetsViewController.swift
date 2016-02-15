//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Karlygash Zhuginissova on 2/10/16.
//  Copyright © 2016 Karlygash Zhuginissova. All rights reserved.
//

import UIKit
import SVPullToRefresh


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweetsArray = [Tweet]()
    var tweetsNumber = 0
    
    @IBOutlet weak var tableView: UITableView!
    var pullToRefreshView = SVPullToRefreshView()
   // var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        tableView.reloadData()
        
        tableView.dataSource = self
        tableView.delegate = self
      
        refresh()
        infiniteScroll()
        
    }
    
    func refresh() {
        //let weakSelf: TweetsViewController = self

        tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.insertRowAtTop()
        
        }
    }
    
    func infiniteScroll() {
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.insertRowAtBottom()
        }
    }
    
    
 
//    func pullToRefreshControl() {
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
//
//        tableView.insertSubview(refreshControl, atIndex: 0)
//    }
//    
//    func onRefresh() {
//        delay(2, closure: {
//            self.refreshControl.endRefreshing()
//        })
//    }
//    
//    func delay(delay: Double, closure: () -> () ) {
//        dispatch_after(
//            dispatch_time(
//                DISPATCH_TIME_NOW,
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), closure
//        )
//    }
//    
    func insertRowAtTop() {
        //let weakSelf: TweetsViewController = self
        let delayInSeconds: Int64 = 3
        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
            self.tableView.beginUpdates()
            self.tableView.insertSubview(self.pullToRefreshView, atIndex: 0)
            self.retrieveData()
            self.tableView.reloadData()
           // weakSelf.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Bottom)
            self.tableView.endUpdates()
            self.tableView.pullToRefreshView.stopAnimating()
        })
    }
    
    func insertRowAtBottom() {
        //var weakSelf: SVViewController = self
        let delayInSeconds: Int64 = 3
        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
            self.tableView.beginUpdates()
            self.loadMoreTweets()
            //self.tweetsArray.append(self.tweetsArray.last!)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tweetsArray.count - 1, inSection: 0)], withRowAnimation: .Top)
            self.tableView.endUpdates()
            self.tableView.infiniteScrollingView.stopAnimating()
        })
    }
    
    func retrieveData() {
        TwitterClient.sharedInstance.homeTimeLineWithCompletion(nil) { (tweets, error) -> () in
            print("Number of tweet: \(tweets?.count)")
            self.tweetsArray = tweets!
//            
//            for tweet in tweets! {
//                self.tweetsArray.append(tweet)
//                self.tableView.reloadData()
//            }
        }
    }
    
    func loadMoreTweets() {
        let dictionary = NSMutableDictionary()
        tweetsNumber = tweetsNumber + 20
        dictionary["count"] = tweetsNumber
        
        TwitterClient.sharedInstance.homeTimeLineWithCompletion(nil) { (tweets, error) -> () in
                self.tweetsArray = tweets!
              }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.tweetsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweetsArray[indexPath.row]
        print("I am here")
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func onLogout(sender: AnyObject) {
//        User.currentUser?.logout()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
