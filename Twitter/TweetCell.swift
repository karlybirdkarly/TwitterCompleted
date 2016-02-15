//
//  TweetCell.swift
//  Twitter
//
//  Created by Karlygash Zhuginissova on 2/10/16.
//  Copyright © 2016 Karlygash Zhuginissova. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

   
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    let defaults = NSUserDefaults.standardUserDefaults()

    


    //button.setImage(UIImage(named: "Checked"), forState: .Selected)
    
    var tweet: Tweet! {
        didSet {
            
            screennameLabel.text = tweet?.user?.name
            usernameLabel.text = tweet?.user?.screenName
            descriptionLabel.text = tweet?.text
            if tweet?.user?.profileImageUrl != nil {
                profileImageView.setImageWithURL(NSURL(string: (tweet?.user?.profileImageUrl)!)!)
            }
            if (tweet?.favoritesCount)! == 0 {
                likesCountLabel.hidden = true
            } else {
                likesCountLabel.text = String((tweet?.favoritesCount)!)
            }

            if (tweet?.retweetedCount)! == 0 {
                retweetsCountLabel.hidden = true
            } else {
                retweetsCountLabel.text = String((tweet?.retweetedCount)!)
            }
            createdAgoLabel.text = tweet.ago
                        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        screennameLabel.preferredMaxLayoutWidth = screennameLabel.frame.size.width
        
//        if let likedOrNot = defaults.valueForKey("liked") {
//            self.likeButton.selected = likedOrNot as! Bool
//        } else {
            likeButton.selected = false
       // }
        likeButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like-action-on.png"), forState: .Selected)
        
       
    }
    
    @IBAction func onLike(sender: AnyObject) {
        if let button = sender as? UIButton {
            if button.selected {
                // set selected
                
                
               TwitterClient.sharedInstance.likeCreateTweetWithCompletion(tweet.id!){
                    (error: NSError?) in
                    if error == nil {
                        self.tweet.favoritesCount! -= 1
                        self.likesCountLabel.text = String( self.tweet.favoritesCount!)
                        button.selected = true
                    }
                }
            } else {
                TwitterClient.sharedInstance.likeDestroyTweetWithCompletion(tweet.id!){
                    (error: NSError?) in
                    if error == nil {
                        self.tweet.favoritesCount! += 1
                        self.likesCountLabel.text = String( self.tweet.favoritesCount!)
                        button.selected = false
                    }
                }
            }
            let liked = likeButton.selected
            print(liked)
            //defaults.setValue(liked, forKey: "liked")
        }
    }
    func likedComplete() {
        likeButton.selected = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
