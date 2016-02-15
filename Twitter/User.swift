//
//  User.swift
//  Twitter
//
//  Created by Karlygash Zhuginissova on 2/9/16.
//  Copyright © 2016 Karlygash Zhuginissova. All rights reserved.
//

import UIKit

var _currentUser: User?
var currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var userDictionary: NSDictionary

    init (dictionary: NSDictionary) {
        self.userDictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
        
            if _currentUser == nil {
            let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let userDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        _currentUser = User(dictionary: userDictionary)
                    } catch(let error) {
                            print(error)
                            assert(false)
                        }
                }
            }
            return _currentUser
        }
        
        
        set(user){
         _currentUser = user
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.userDictionary, options: NSJSONWritingOptions.PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch(let error) {
                    print(error)
                    assert(false)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }  
    }
    
}
