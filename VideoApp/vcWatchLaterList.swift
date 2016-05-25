//
//  vcWatchLaterList.swift
//  VideoApp
//
//  Created by macbook on 4/19/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcWatchLaterList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listWachLater = [movieObject]()
    var userid: Int = 0
    var accesstoken:String = ""
    
    var movieWatchLater: movieObject?
    
    @IBOutlet weak var tableWachLater: UITableView!
    
    @IBAction func popup(sender: AnyObject) {
        //self.ViewFunc()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let subviewWidth = 300
        let subviewHeight = 250
        
        let subviewX:Int = Int( (Int(screenWidth) - Int(subviewWidth))/2 )
        let subviewY:Int = Int( (Int(screenHeight) - Int(subviewHeight))/2 )
        
        let mySubView:customView = customView(frame: CGRect(x:subviewX, y: subviewY, width: subviewWidth, height: subviewHeight))
        self.view.addSubview(mySubView)

        
        mySubView.tag = 100

        mySubView.layer.cornerRadius = 12
        mySubView.layer.borderColor = UIColor.blackColor().CGColor
        mySubView.layer.borderWidth = 1
        mySubView.layer.shadowRadius = 2
        mySubView.layer.cornerRadius = 12
        
        mySubView.closePopup.addTarget(self, action: "removeSubview:", forControlEvents: UIControlEvents.TouchUpInside)
        mySubView.buttonTerm.addTarget(self, action: "openTermview:", forControlEvents: UIControlEvents.TouchUpInside)
        mySubView.buttonDisclaimer.addTarget(self, action: "openDisclaimerview:", forControlEvents: UIControlEvents.TouchUpInside)
        mySubView.buttonContact.addTarget(self, action: "openContactview:", forControlEvents: UIControlEvents.TouchUpInside)
        /*
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } 
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
        */
    }
    func openTermview(sender:UIButton) {
        let termViewController = self.storyboard?.instantiateViewControllerWithIdentifier("termView") as! TermViewController
        self.navigationController?.pushViewController(termViewController, animated: true)
    }
    
    func openDisclaimerview(sender:UIButton) {
        let disclaimerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("disclaimerView") as! DisclaimerViewController
        self.navigationController?.pushViewController(disclaimerViewController, animated: true)
    }
    
    func openContactview(sender:UIButton) {
        let contactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contactView") as! ContactViewController
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func removeSubview(sender:UIButton) {
        for v in view.subviews{
            if (v.tag == 100) {
                v.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        accesstoken = defaults.objectForKey("accesstoken") as! String
        userid = defaults.integerForKey("userid")
        if( accesstoken != ""){
            let paramWatched=[
                "page_size" : "100",
                "access_token" : accesstoken
            ]
            
            let urlWatched = "http://api.filmify.net/api/movies-watch-later-list/" + String(userid)
            self.getServer(urlWatched, successBlock: { data in
                let jsonListing = data!["results"] as? NSArray
                //print(jsonListing)
                if(jsonListing!.count > 0){
                    for item in jsonListing as! [AnyObject]{
                        //let title:String = (item.valueForKey("description") as? String)!
                        let movie = item.valueForKey("movie")! as AnyObject
                        
                        let movieId: Int = movie.valueForKey("id") as! Int
                        let poster:String? = movie.valueForKey("poster") as? String
                        let title:String? = movie.valueForKey("title") as? String
                        let year:Int? = movie.valueForKey("year") as? Int
                        let director:String? = movie.valueForKey("director") as? String
                        let actors:String? = movie.valueForKey("main_cast") as? String
                        
                        let trailer: String
                        if(movie.valueForKey("trailer") is NSNull){
                            trailer = "https://www.youtube.com/embed/DOUvmXXFvEI?&playsinline=1"
                        }else{
                            trailer = movie.valueForKey("trailer") as! String
                        }
                        
                        let plot: String = movie.valueForKey("plot") as! String
                        
                        self.listWachLater.append(movieObject(mid: movieId, pIn: poster!, tIn: title!, yIn: year!, dIn: director!, aIn: actors!, plotIn: plot, trailIn: trailer))
                    }
                    self.tableWachLater.reloadData()
                }else{
                    print("none of movie")
                    self.createAlertView("Warning", message: "Non movies in list, please add to list", buttonTitle: "OK")
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }, error: {error in
                //error
            }, parameters: paramWatched)
                
        }else{
            
        }
        
        
        self.tableWachLater.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWachLater.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellWachLater", forIndexPath: indexPath) as! customCell
        let item = listWachLater[indexPath.row]
        cell.lblTitle.text = item.title
        
        cell.lblYear.text = String(item.year! as Int)
        cell.lblDirector.text = item.director
        
        cell.lblActors.text = item.actors
        cell.lblActors.numberOfLines = 0
        cell.lblActors.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        requestImage( item.poster! ) { (image) -> Void in
            cell.poster.image = image
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let idkey:Int = indexPath!.row
        movieWatchLater = self.listWachLater[idkey]
        self.performSegueWithIdentifier("watchlaterDetailSegue", sender: tableView)
        
    }
    
    @IBAction func imgBack(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }

    
    func requestImage(url: String, success: (UIImage?) -> Void) {
        requestURL(url, success: { (data) -> Void in
            if let d = data {
                success(UIImage(data: d))
            }
        })
    }
    
    func requestURL(url: String, success: (NSData?) -> Void, error: ((NSError) -> Void)? = nil) {
        NSURLConnection.sendAsynchronousRequest(
            NSURLRequest(URL: NSURL (string: url)!),
            queue: NSOperationQueue.mainQueue(),
            completionHandler: { response, data, err in
                if let e = err {
                    error?(e)
                } else {
                    success(data)
                }
        })
    }
    
    func getServer(link: String, successBlock:(data:AnyObject?)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.GET, link , parameters: parameters as? [String : AnyObject])
            .responseJSON { response in switch response.result {
                
            case .Success(let JSON):
                let data: AnyObject? = JSON
                successBlock(data: data)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                errorBlock(error: error)
                }
                
        }
    }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "watchlaterDetailSegue") {
            let svc = segue.destinationViewController as! vcResult;
            svc.movieCurrent = movieWatchLater
            svc.listMovies = listWachLater
        }
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
