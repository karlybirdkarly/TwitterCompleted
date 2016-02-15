//
//  TwitterClient.swift
//  Twitter
//
//  Created by Karlygash Zhuginissova on 2/8/16.
//  Copyright © 2016 Karlygash Zhuginissova. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "0kZFFFtynEcoUNF52qKOD2i8I"
let twitterConsumerSecret = "EplRELkdshMZ9AnxlvfknKfSrkULQDlMvLKvvs1cxLkJUCu8Lu"

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
        class var sharedInstance: TwitterClient {
            struct Static {
//                let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
//                let twitterConsumerKey = "0kZFFFtynEcoUNF52qKOD2i8I"
//                let twitterConsumerSecret = "EplRELkdshMZ9AnxlvfknKfSrkULQDlMvLKvvs1cxLkJUCu8Lu"
             
                static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
                    }
        return Static.instance
    }
    
    func homeTimeLineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("/1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("home timeline: \(response!)")
            let tweets = Tweet.tweetsWithArray(response! as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home page")
            completion(tweets: nil, error: error)
        })
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch my request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
           
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
               
        }
        
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString:url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("/1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                // print("current user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name!)")
                self.loginCompletion?(user:user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                     self.loginCompletion?(user: nil, error:  error)
            })
            
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive acces token")
        }
    }
    
    func likeCreateTweetWithCompletion(likedTweetId: String, completion: (error: NSError?) -> ()) {
        
        if _currentUser != nil {
            
            let likedTweet = NSMutableDictionary()
             likedTweet["id"] = likedTweetId
            
            TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: likedTweet, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("Tweet is liked")
                //do someething when succeeded
                completion(error: nil)
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Failed to like this tweet")
                  
                    completion(error: error)
                   
            })
        }
    }
    
    func likeDestroyTweetWithCompletion(likedTweetId: String, completion: (error: NSError?) -> ()) {
        
        if _currentUser != nil {
            
            let likedTweet = NSMutableDictionary()
            likedTweet["id"] = likedTweetId
            
            TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json", parameters: likedTweet, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("Tweet is unliked")
                //do someething when succeeded
                completion(error: nil)
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Failed to unlike this tweet")
                    
                    completion(error: error)
                    
            })
        }
    }

   
}
