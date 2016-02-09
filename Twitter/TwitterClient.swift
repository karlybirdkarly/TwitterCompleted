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
    
        class var sharedInstance: TwitterClient {
            struct Static {
//                let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
//                let twitterConsumerKey = "0kZFFFtynEcoUNF52qKOD2i8I"
//                let twitterConsumerSecret = "EplRELkdshMZ9AnxlvfknKfSrkULQDlMvLKvvs1cxLkJUCu8Lu"
             
                static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
                    }
        return Static.instance
    }

}
