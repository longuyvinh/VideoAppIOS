//
//  vcSignup.swift
//  VideoApp
//
//  Created by macbook on 4/26/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

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
    
    @IBAction func buttonSignup(sender: AnyObject) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
