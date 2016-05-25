//
//  vcCategory.swift
//  VideoApp
//
//  Created by macbook on 4/21/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcCategory: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var viewFrameTable: UIView!
    //let listGenre = ["Action", "Adventure", "Fantasy", "Animation", "Comedy" , "Comedy11"]
    var listGenre = [Genre]()
    @IBOutlet weak var myTableView: UITableView!
    
    var currentCategory:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.transform=CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        myTableView.translatesAutoresizingMaskIntoConstraints = true;

        var frame = myTableView.frame
        frame.origin.y = 0
        frame.origin.x = 0
        frame.size.width  = self.view.frame.size.width
        frame.size.height = viewFrameTable.frame.size.height
        myTableView.frame = frame
        myTableView.backgroundColor = UIColor.blackColor()
        
        self.navigationController?.navigationBarHidden = true

        var accesstoken:String
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if(defaults.objectForKey("accesstoken") != nil){
            accesstoken = defaults.objectForKey("accesstoken") as! String
        }else{
            accesstoken = ""
        }
        print("access token: \(accesstoken)")
        
        if( accesstoken != ""){
            let paramListGenres=[
                "page": "1",
                "page_size" : "1000",
                "ordering" : "name",
                "access_token" : accesstoken
            ]
        
            let urlGenres = "http://api.filmify.net/api/genres/"

            self.requestServer(urlGenres,
                               successBlock:{(data) in
                                //print(data!["results"])
                                let jsonListing = data!["results"] as? NSArray
                                //print(jsonListing)
                                for item in jsonListing as! [AnyObject]{
                                    //let title:String = (item.valueForKey("description") as? String)!
                                    let genreId:Int = (item.valueForKey("id") as? Int)!
                                    let genreName:String = (item.valueForKey("description") as? String)!
                                    self.listGenre.append(Genre(idIn: genreId as Int, nameIn: genreName as String))
                    
                                    //self.listGenre.append(title)
                                    //print(title)
                                }
                                //print(self.listGenre)
                                self.myTableView.reloadData()
                            },
                            error:{(error) in
                                //error
                            },
                            parameters: paramListGenres)
        }else{
            print("token error")
            /*
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("startView") as! vcStart
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = protectedPageNav
            */
        }
        
        //self.createAlertController()
   }

    func requestServer(link: String, successBlock:(data:AnyObject?)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.GET, link, parameters: parameters as? [String : AnyObject]).responseJSON{
            response in
            // nen dung swich case ngay day ...
            if let JSON = response.result.value{
                let data: AnyObject? = JSON
                successBlock(data: data)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenre.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        let item = listGenre[indexPath.row]
        cell.textLabel!.text = item.name
        
        cell.textLabel!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        cell.textLabel?.textAlignment = .Center
        
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0, green: 0.9922, blue: 0.7843, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        cell.textLabel!.font = UIFont(name:"Amatic", size:30)
        //cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {


    }
  
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.00
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let idkey:Int = indexPath!.row
        currentCategory = self.listGenre[idkey].id!
        //print("show current genre \(currentCategory)")
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionPlay(sender: AnyObject) {
        if(currentCategory == -1){
            self.createAlertView("Warning", message: "Please choose one category", buttonTitle: "Ok")
        }else{
            self.performSegueWithIdentifier("seguePlayDetail", sender: self)
            //self.performSegueWithIdentifier("scrollViewSegue", sender: self)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "seguePlayDetail") {
            let svc = segue.destinationViewController as! vcResult
            svc.genrePassed = currentCategory
        }
        
        if (segue.identifier == "scrollViewSegue") {
            let svc = segue.destinationViewController as! vcSwipe
            svc.genrePassed = currentCategory
        }
    }
    
    
    //comment out kieu alert
    /*
    func createAlertView(title:String, message:String, buttonTitle: String){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        //let fontAwesomeFont = UIFont(name:"Amatic", size:30)
        createAccountErrorAlert.delegate = self
        
        //createAccountErrorAlert.setValue(attributedTitleString, "attributedTitle")
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
    
    
    
    func getServer(link: String, successBlock:(data:[NSObject : AnyObject])-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.GET, link , parameters: parameters as? [String : AnyObject], encoding: .JSON)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    successBlock(data: JSON as! [NSObject : AnyObject])
                }
        }
    }
    /*
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
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
