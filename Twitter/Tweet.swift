//
//  Tweet.swift
//  Twitter
//
//  Created by Karlygash Zhuginissova on 2/9/16.
//  Copyright © 2016 Karlygash Zhuginissova. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoritesCount: Int?
    var retweetedCount: Int?
    var ago: String?
    var id: String?

    init (dictionary: NSDictionary){
       
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favoritesCount = dictionary["favorite_count"] as? Int
        print("favorites here: \(dictionary["favorite_count"])")
        retweetedCount = dictionary["retweet_count"] as? Int
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let interval = abs(createdAt!.timeIntervalSinceNow)
        let secAgo = Int(interval)
         print("Interval aaaaaaaaaaaa: \(interval)")
        print("Seconds interval: \(secAgo)")
        if secAgo < 60 {
            ago = String(secAgo) + "s"
            print("Seconds ago: \(ago)")
        } else if (secAgo >= 60 && secAgo < 3600) {
            ago = String(secAgo/60) + "m"
            print("Minutes ago: \(ago)")
        } else if secAgo >= 3600 {
            ago = String(secAgo/3600) + "h"
            print("Hours ago: \(ago)")
        }
        
        id = dictionary["id_str"] as? String
        
    }
    class func tweetsWithArray(arrayOfDictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for oneDictionary in arrayOfDictionaries {
            tweets.append(Tweet(dictionary: oneDictionary))
        }
        
        return tweets
    }
    
}
