//
//  vcStart.swift
//  VideoApp
//
//  Created by macbook on 4/19/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Alamofire

class vcStart: UIViewController, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var loginFacebook: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("User is not logged in")
        }else{
            print("User is not logged")
        }*/
        
        //get time now
        let date = NSDate()
        let timestamp = Int(date.timeIntervalSince1970)
        var accesstoken:String
        var refeshtoken:String
        var expiretime:Int
        let clientID = "cWRbW1jW3j0aqkLPZOd1aSPsjQoh0RI4q6UgDhod"
        let clientSecret = "0TL52Fg9hBgGYl8LY9xD8FvWj228yhnckhMH7mY8hunpXKimNIO5sDpJQPnMSG4gDeVxXdRbmIvgJ4mNzTwoKSQ6KxMNYE77CI6nkbjfdwHlykjY1fRfMnRPj3JTQS5E"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("accesstoken") != nil){
             accesstoken = defaults.objectForKey("accesstoken") as! String
        }else{
            accesstoken = ""
        }
        
        if(defaults.objectForKey("refreshtoken") != nil){
            refeshtoken = defaults.objectForKey("refreshtoken") as! String
        }else{
            refeshtoken = ""
        }
        
        if(defaults.objectForKey("expiretime") != nil){
            expiretime = defaults.objectForKey("expiretime") as! Int
        }else{
            expiretime = 0
        }
        
        if(accesstoken != "") && (expiretime >= timestamp){
            //token still available and redirect to home category
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("homeCategory") as! vcCategory
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = protectedPageNav
        }else if((expiretime < timestamp) && (accesstoken != "")){
            //token expire timeout
            print("expired timeout")
            
            let paramAuth = [
                "grant_type":       "refresh_token",
                "client_id":        clientID,
                "client_secret":    clientSecret,
                "refresh_token":    refeshtoken
            ]
            let url = "http://filmify.yieldlevel.co/auth/token"
            
            Alamofire.request(.POST, url, parameters: paramAuth)
                .responseJSON { response in
                    
                    if let JSON = response.result.value {
                        accesstoken = (JSON["access_token"] as? String)!
                        refeshtoken = (JSON["refresh_token"] as? String)!
                        expiretime = (JSON["expires_in"] as? Int)!
                        
                        let expireTime = timestamp + expiretime
                        defaults.setObject(accesstoken, forKey: "accesstoken")
                        defaults.setObject(refeshtoken, forKey: "refreshtoken")
                        defaults.setInteger(expireTime, forKey: "expiretime")
                        
                        //redirect to view home category
                        let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("homeCategory") as! vcCategory
                        let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window?.rootViewController = protectedPageNav
                        //redirect to view home category EOF
                    }
                    
            }
        }
        
        loginFacebook.delegate = self
        loginFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(FBSDKAccessToken.currentAccessToken() != nil){
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("homeCategory") as! vcCategory
            
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = protectedPageNav
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil){
            print(error.localizedDescription)
            return
        }
        
        if let userToken = result.token{
            //get user access token
            //let token:FBSDKAccessToken = result.token
            print("Token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("User ID: \(FBSDKAccessToken.currentAccessToken().userID)")
            
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("homeCategory") as! vcCategory
            
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = protectedPageNav
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
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
