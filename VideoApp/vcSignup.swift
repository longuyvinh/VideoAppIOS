//
//  vcSignup.swift
//  VideoApp
//
//  Created by macbook on 4/26/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcSignup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var constrainsHeightView: NSLayoutConstraint!
    
    @IBOutlet weak var frameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        self.txtUsername.delegate = self
        self.txtFirstname.delegate = self
        self.txtLastname.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        /*
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))

        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        */
        
        
    }
    
    /*
    //----Notifi Hide KeyBoard -----//
    (void)keyboardWillHide:(NSNotification *)notification{
        _constraintsTopLabel.constant = currentConstraintsToplabel
        _constraintsTopViewTop.constant = currentConstraintsViewTop
        [self.view layoutIfNeeded]
    }

    (void)keyboardWillShow:(NSNotification *)notification
    {
        // Step 1: Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        float sumConstraintView = (constraintsHeightLabel.constant + constraintsTopLabel.constant) + ( constraintsTopViewTop.constant + constraintsHeightViewTop.constant)
        if (self.view.frame.size.height - sumConstraintView < keyboardSize.height){
            float index = (sumConstraintView - keyboardSize.height)
            _constraintsTopLabel.constant = - currentConstraintsToplabel - index
            //        _constraintsTopViewTop.constant = - currentConstraintsViewTop - index;
            [self.view layoutIfNeeded]
        }
    }*/
    func getRequest(link: String, successBlock:(data:AnyObject?)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.GET, link , parameters: parameters as? [String : AnyObject])
            .responseJSON { response in switch response.result {
                
            case .Success(let JSON):
                successBlock(data: JSON as! [String : AnyObject])
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                errorBlock(error: error)
                }
                
        }
    }
    
    func requestServer(link: String, successBlock:(data:[String : AnyObject] , stautusCode: Int)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.POST, link , parameters: parameters as? [String : AnyObject])
            .responseJSON { response in switch response.result {
                
            case .Success(let JSON):
                var statusCode:Int
                statusCode = (response.response?.statusCode)!
                successBlock(data: JSON as! [String : AnyObject] , stautusCode: statusCode)
                                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                errorBlock(error: error)
            }
                
        }
    }
    
    
    @IBAction func buttonSignup(sender: AnyObject) {
        var errorFlah:Int = 0
        
        let fname:String = txtFirstname.text!
        let lname:String = txtLastname.text!
        let email:String = txtEmail.text!
        let password:String = txtPassword.text!
        let username:String = txtUsername.text!

        if fname.isEmpty{
            self.createAlertView("Error", message: "First name can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if lname.isEmpty{
            self.createAlertView("Error", message: "Last name can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if username.isEmpty{
            self.createAlertView("Error", message: "Username can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if email.isEmpty{
            self.createAlertView("Error", message: "Email can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if !isValidEmail(email){
            self.createAlertView("Error", message: "This is not an email", buttonTitle: "Retry")
            errorFlah = 1
        }else if password.isEmpty{
            self.createAlertView("Error", message: "Password can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }
        
        if(errorFlah != 1){
            let paramSignup = [
                "first_name":   fname,
                "last_name":    lname,
                "username":     username,
                "password":     password,
                "email":        email
            ]
            let url1:String = "http://filmify.yieldlevel.co/api/register/"
            
            self.requestServer(url1, successBlock: { (data, stautusCode) in
                if stautusCode != 201 {
                    print("error field")
                    //username, email, last_name:max 30 ki tu, first_name:max 30 ki tu

                    if(data["username"] != nil){
                        let usernameErr = data["username"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorUsername:String = ""
                        for err1 in usernameErr{
                            ErrorUsername = ErrorUsername + (err1 as! String) + "\n"
                        }
                        self.createAlertView("Error Username", message: ErrorUsername, buttonTitle: "Retry")
                    }
                    
                    if(data["email"] != nil){
                        let emailErr = data["email"] as! NSArray
                        var ErrorEmail:String = ""
                        for err in emailErr{
                            ErrorEmail = ErrorEmail + (err as! String) + "\n"
                        }
                        self.createAlertView("Error Email", message: ErrorEmail, buttonTitle: "Retry")
                    }
                    
                    if(data["last_name"] != nil){
                        let lastnameErr = data["last_name"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorLastname:String = ""
                        for err in lastnameErr{
                            ErrorLastname = ErrorLastname + (err as! String) + "\n"
                        }
                        self.createAlertView("Error Last Name", message: ErrorLastname, buttonTitle: "Retry")
                    }
                    
                    if(data["first_name"] != nil){
                        let firstnameErr = data["first_name"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorFirstname:String = ""
                        for err in firstnameErr{
                            ErrorFirstname = ErrorFirstname + (err as! String) + "\n"
                        }
                        self.createAlertView("Error First Name", message: ErrorFirstname, buttonTitle: "Retry")
                    }
                    
                    //print(ErrorUsername)
                    //print(data)
                } else {
                    //print("success")
                    //print(data)
                    //[id: 46, username: longuyvinh, first_name: vinh, email: longuyvinh.ny@gmail.com, last_name: Nguyen]
                    let usernameRS:String = (data["username"] as? String)!
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    let date = NSDate()
                    let timestamp = Int(date.timeIntervalSince1970)
                    
                    let clientID = "cWRbW1jW3j0aqkLPZOd1aSPsjQoh0RI4q6UgDhod"
                    let clientSecret = "0TL52Fg9hBgGYl8LY9xD8FvWj228yhnckhMH7mY8hunpXKimNIO5sDpJQPnMSG4gDeVxXdRbmIvgJ4mNzTwoKSQ6KxMNYE77CI6nkbjfdwHlykjY1fRfMnRPj3JTQS5E"
                    
                    let paramAuth = [
                        "grant_type":       "password",
                        "client_id":        clientID,
                        "client_secret":    clientSecret,
                        "username":         usernameRS,
                        "password":         password
                    ]
                    let url = "http://filmify.yieldlevel.co/auth/token"
                    self.requestServer(url, successBlock: { (data, stautusCode) in
                            //print(data)
                            let accesstoken = (data["access_token"] as? String)!
                            let refeshtoken = (data["refresh_token"] as? String)!
                            let expiretime = (data["expires_in"] as? Int)!
                            let expireTime = timestamp + expiretime
                        
                            defaults.setObject(accesstoken, forKey: "accesstoken")
                            defaults.setObject(refeshtoken, forKey: "refreshtoken")
                            defaults.setInteger(expireTime, forKey: "expiretime")
                            defaults.setObject(usernameRS, forKey: "username")
                            self.performSegueWithIdentifier("segueIdentifier", sender: self)
                        }, error: { (error) in
                            //error
                        }, parameters: paramAuth)
                    
                }
                
                }, error: { (error) in
                    //error
                }, parameters: paramSignup)

        }
    }
    
    @IBAction func signup(sender: AnyObject) {
    
        var errorFlah:Int = 0
        
        let fname:String = txtFirstname.text!
        let lname:String = txtLastname.text!
        let email:String = txtEmail.text!
        let password:String = txtPassword.text!
        let username:String = txtUsername.text!
        
        if fname.isEmpty{
            self.createAlertView("Error", message: "First name can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if lname.isEmpty{
            self.createAlertView("Error", message: "Last name can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if username.isEmpty{
            self.createAlertView("Error", message: "Username can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if email.isEmpty{
            self.createAlertView("Error", message: "Email can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }else if !isValidEmail(email){
            self.createAlertView("Error", message: "This is not an email", buttonTitle: "Retry")
            errorFlah = 1
        }else if password.isEmpty{
            self.createAlertView("Error", message: "Password can not blank", buttonTitle: "Retry")
            errorFlah = 1
        }
        
        if(errorFlah != 1){
            let paramSignup = [
                "first_name":   fname,
                "last_name":    lname,
                "username":     username,
                "password":     password,
                "email":        email
            ]
            let url1:String = "http://filmify.yieldlevel.co/api/register/"
            
            self.requestServer(url1, successBlock: { (data, stautusCode) in
                if stautusCode != 201 {
                    print("error field")
                    //username, email, last_name:max 30 ki tu, first_name:max 30 ki tu
                    
                    if(data["username"] != nil){
                        let usernameErr = data["username"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorUsername:String = ""
                        for err1 in usernameErr{
                            ErrorUsername = ErrorUsername + (err1 as! String) + "\n"
                        }
                        self.createAlertView("Error Username", message: ErrorUsername, buttonTitle: "Retry")
                    }
                    
                    if(data["email"] != nil){
                        let emailErr = data["email"] as! NSArray
                        var ErrorEmail:String = ""
                        for err in emailErr{
                            ErrorEmail = ErrorEmail + (err as! String) + "\n"
                        }
                        self.createAlertView("Error Email", message: ErrorEmail, buttonTitle: "Retry")
                    }
                    
                    if(data["last_name"] != nil){
                        let lastnameErr = data["last_name"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorLastname:String = ""
                        for err in lastnameErr{
                            ErrorLastname = ErrorLastname + (err as! String) + "\n"
                        }
                        self.createAlertView("Error Last Name", message: ErrorLastname, buttonTitle: "Retry")
                    }
                    
                    if(data["first_name"] != nil){
                        let firstnameErr = data["first_name"] as! NSArray
                        //let totalErr = usernameErr.count
                        var ErrorFirstname:String = ""
                        for err in firstnameErr{
                            ErrorFirstname = ErrorFirstname + (err as! String) + "\n"
                        }
                        self.createAlertView("Error First Name", message: ErrorFirstname, buttonTitle: "Retry")
                    }
                    
                    //print(ErrorUsername)
                    //print(data)
                } else {
                    //print("success")
                    //print(data)
                    //[id: 46, username: longuyvinh, first_name: vinh, email: longuyvinh.ny@gmail.com, last_name: Nguyen]
                    let usernameRS:String = (data["username"] as? String)!
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    let date = NSDate()
                    let timestamp = Int(date.timeIntervalSince1970)
                    
                    let clientID = "cWRbW1jW3j0aqkLPZOd1aSPsjQoh0RI4q6UgDhod"
                    let clientSecret = "0TL52Fg9hBgGYl8LY9xD8FvWj228yhnckhMH7mY8hunpXKimNIO5sDpJQPnMSG4gDeVxXdRbmIvgJ4mNzTwoKSQ6KxMNYE77CI6nkbjfdwHlykjY1fRfMnRPj3JTQS5E"
                    
                    let paramAuth = [
                        "grant_type":       "password",
                        "client_id":        clientID,
                        "client_secret":    clientSecret,
                        "username":         usernameRS,
                        "password":         password
                    ]
                    let url = "http://filmify.yieldlevel.co/auth/token"
                    self.requestServer(url, successBlock: { (data, stautusCode) in
                        //print(data)
                        let accesstoken = (data["access_token"] as? String)!
                        let refeshtoken = (data["refresh_token"] as? String)!
                        let expiretime = (data["expires_in"] as? Int)!
                        let expireTime = timestamp + expiretime
                        
                        defaults.setObject(accesstoken, forKey: "accesstoken")
                        defaults.setObject(refeshtoken, forKey: "refreshtoken")
                        defaults.setInteger(expireTime, forKey: "expiretime")
                        defaults.setObject(usernameRS, forKey: "username")
                        self.performSegueWithIdentifier("segueIdentifier", sender: self)
                        }, error: { (error) in
                            //error
                        }, parameters: paramAuth)
                    
                }
                
                }, error: { (error) in
                    //error
                }, parameters: paramSignup)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }*/
    
    /*
    func createAlertView(title:String, message:String, buttonTitle: String){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        
        createAccountErrorAlert.title = title
        createAccountErrorAlert.message = message
        createAccountErrorAlert.addButtonWithTitle(buttonTitle)
        
        createAccountErrorAlert.show()
    }*/
    func createAlertView(title:String, message:String, buttonTitle: String){
        let attributedTitleString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont(name:"Amatic", size:30)!,
            NSForegroundColorAttributeName : UIColor.blackColor()
            ])
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.setValue(attributedTitleString, forKey: "attributedTitle")
        
        //UIAlertActionStyle have 3 option: Destructive, Default, Cancel
        let libButton = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { (alert) -> Void in
            //vinh note: please add action here
            //self.presentViewController(imageController, animated: true, completion: nil)
        }
        alert.addAction(libButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    func DismissKeyboard(){
        self.view.endEditing(true)
    }

}
