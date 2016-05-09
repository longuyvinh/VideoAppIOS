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
    
    //"http://filmify.yieldlevel.co/api/register/"
    func requestServer(link: String, successBlock:(data:[NSObject : AnyObject] , stautusCode: Int)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.POST, link , parameters: parameters as? [String : AnyObject], encoding: .JSON)
            .responseJSON { response in switch response.result {
                
            case .Success(let JSON):
                var statusCode:Int
                statusCode = (response.response?.statusCode)!
                successBlock(data: JSON as! [NSObject : AnyObject] , stautusCode: statusCode)
                                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                errorBlock(error: error)
            }
                
        }
    }
    
    
    @IBAction func buttonSignup(sender: AnyObject) {
        let errorFlah:Int = 0
        
        let fname:String = txtFirstname.text!
        let lname:String = txtLastname.text!
        let email:String = txtEmail.text!
        let password:String = txtPassword.text!
        let username:String = txtUsername.text!
      
        // sao no ko vao ta
        //alo
//        if fname.isEmpty{
//            self.createAlertView("Error", message: "First name can not blank", buttonTitle: "Retry")
//            errorFlah = 1
//        }else if lname.isEmpty{
//            self.createAlertView("Error", message: "Last name can not blank", buttonTitle: "Retry")
//            errorFlah = 1
//        }else if username.isEmpty{
//            self.createAlertView("Error", message: "Username can not blank", buttonTitle: "Retry")
//            errorFlah = 1
//        }else if email.isEmpty{
//            self.createAlertView("Error", message: "Email can not blank", buttonTitle: "Retry")
//            errorFlah = 1
//        }else if !isValidEmail(email){
//            self.createAlertView("Error", message: "This is not an email", buttonTitle: "Retry")
//            errorFlah = 1
//        }else if password.isEmpty{
//            self.createAlertView("Error", message: "Password can not blank", buttonTitle: "Retry")
//            errorFlah = 1
//        }
        
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
                    //print(data)
                } else {
                    //print("success")
                    //print(data)
                    //[id: 46, username: longuyvinh, first_name: vinh, email: longuyvinh.ny@gmail.com, last_name: Nguyen]
                    
                    let usernameRS:String = (data["username"] as? String)!
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    
                    
                    
                    let date = NSDate()
                    let timestamp = Int(date.timeIntervalSince1970)
                    
                    //self.performSegueWithIdentifier("segueIdentifier", sender: self)
                    let clientID = "cWRbW1jW3j0aqkLPZOd1aSPsjQoh0RI4q6UgDhod"
                    let clientSecret = "0TL52Fg9hBgGYl8LY9xD8FvWj228yhnckhMH7mY8hunpXKimNIO5sDpJQPnMSG4gDeVxXdRbmIvgJ4mNzTwoKSQ6KxMNYE77CI6nkbjfdwHlykjY1fRfMnRPj3JTQS5E"
                    
                    let paramAuth = [
                        "grant_type":       "password",
                        "client_id":        clientID,
                        "client_secret":    clientSecret,
                        "username":         username,
                        "password":         password
                    ]
                    let url = "http://filmify.yieldlevel.co/auth/token"
                    
                    Alamofire.request(.POST, url, parameters: paramAuth).responseJSON { response in
                            /*
                            if let JSON = response.result.value {
                                accesstoken = (JSON["access_token"] as? String)!
                                refeshtoken = (JSON["refresh_token"] as? String)!
                                expiretime = (JSON["expires_in"] as? Int)!
                                let expireTime = timestamp + expiretime
                                
                                defaults.setObject(accesstoken, forKey: "accesstoken")
                                defaults.setObject(refeshtoken, forKey: "refreshtoken")
                                defaults.setInteger(expireTime, forKey: "expiretime")
                                defaults.setObject(usernameRS, forKey: "username")
                            }*/
                    }
                    
                }
                
                }, error: { (error) in
                    //error
                }, parameters: paramSignup)

            
//            Alamofire.request(.POST, "http://filmify.yieldlevel.co/api/register/", parameters: parameters, encoding: .JSON)
//                .responseJSON { response in switch response.result {
//                        case .Success(let JSON):
//                                print("success")
//                                var statusCode:Int
//                                statusCode = (response.response?.statusCode)!
//
//                                if(statusCode != 201){
//                                    print("auth error")
//                                    let response = JSON as! NSDictionary
//                                    //example if there is an id
//                                    if ( response.objectForKey("username") != nil ){
//                                        //let errUsername = (JSON.valueForKey("username") as? String)!
//                                        //var uuidString: String? = regionToMonitor["uuid"] as AnyObject? as? String
//                                        let errUsername:String? = JSON.valueForKey("username") as AnyObject? as? String
//                                        //print(errUsername)
//                                        self.createAlertView("Error", message: "\(errUsername)", buttonTitle: "Retry")
//                                    }
//                                    if(response.objectForKey("email") != nil){
//                                        //let errEmail = response.objectForKey("email")
//                                        let errEmail:String? = response.objectForKey("email") as AnyObject? as? String
//                                        //print(errEmail)
//                                        self.createAlertView("Error", message: errEmail!, buttonTitle: "Retry")
//                                    }
//                                    if(response.objectForKey("last_name") != nil){
//                                        let errLname = response.objectForKey("last_name")
//                                        //print(errLname)
//                                        self.createAlertView("Error", message: errLname as! String, buttonTitle: "Retry")
//                                    }
//                                    if(response.objectForKey("first_name") != nil){
//                                        let errFname = response.objectForKey("first_name")
//                                        //print(errFname)
//                                        self.createAlertView("Error", message: errFname as! String, buttonTitle: "Retry")
//                                    }
//                                }else{
//                                    //print("auth success")
//                                    self.createAlertView("Congratulation", message: "Sign up user successful", buttonTitle: "OK")
//                                    
//                                    let parameAuth = [
//                                        "grant_type":       "password",
//                                        "client_id":        "cWRbW1jW3j0aqkLPZOd1aSPsjQoh0RI4q6UgDhod",
//                                        "client_secret":    "0TL52Fg9hBgGYl8LY9xD8FvWj228yhnckhMH7mY8hunpXKimNIO5sDpJQPnMSG4gDeVxXdRbmIvgJ4mNzTwoKSQ6KxMNYE77CI6nkbjfdwHlykjY1fRfMnRPj3JTQS5E",
//                                        "username":         username,
//                                        "password":         password
//                                    ]
//                                    print(parameAuth)
//                                    
//                                    Alamofire.request(.POST, "http://filmify.yieldlevel.co/auth/token/", parameters: parameAuth, encoding: .JSON).responseJSON { response2 in switch response2.result {
//                                        
//                                                case .Success(let JSON2):
//                                                    print(parameters)
//                                                    print("authentication success")
//                                                    print("Success with JSON: \(JSON2)")
//                                                    print(response2.data)
//                                                    print(response2.response)
//                                                    //self.performSegueWithIdentifier("segueIdentifier", sender: self)
//                                                case .Failure(let error2):
//                                                    print("error \(error2)")
//
//                                            }
//                                    }
//                                    
//                                    
//                                }
//                    
//                        case .Failure(let error):
//                                print("Request failed with error: \(error)")
//                    }
//        
//                
//            }
        }
    }
    
    @IBAction func signup(sender: AnyObject) {
    
        let fname:String = txtFirstname.text!
        let lname:String = txtLastname.text!
        let email:String = txtEmail.text!
        let password:String = txtPassword.text!
        let username:String = txtUsername.text!
        
        var errorFlah:Int = 0
        
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
            self.performSegueWithIdentifier("segueIdentifier", sender: self)
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
    
    func createAlertView(title:String, message:String, buttonTitle: String){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        
        createAccountErrorAlert.title = title
        createAccountErrorAlert.message = message
        createAccountErrorAlert.addButtonWithTitle(buttonTitle)
        
        createAccountErrorAlert.show()
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
