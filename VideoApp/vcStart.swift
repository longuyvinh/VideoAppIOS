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

class vcStart: UIViewController, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var loginFacebook: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("User is not logged in")
        }else{
            print("User is not logged")
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
