//
//  vcWachedList.swift
//  VideoApp
//
//  Created by macbook on 4/19/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcWachedList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listWached = [movieObject]()
    
    var imageCache = [String:UIImage]()
    
    var userid: Int = 0
    var accesstoken:String = ""
    var movieWatched: movieObject?

    @IBOutlet weak var tableWached: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Do any additional setup after loading the view.
        self.listWached.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BOTgxMDQwMDk0OF5BMl5BanBnXkFtZTgwNjU5OTg2NDE@._V1_SX300.jpg", tIn:"Inside Out", yIn:"2015", dIn:"Pete Docter", aIn:"Amy Poehler, Phyllis Smith, Richard Kind"))
        self.listWached.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BODUwMDc5Mzc5M15BMl5BanBnXkFtZTcwNDgzOTY0MQ@@._V1_SX300.jpg", tIn:"Spider-Man 3", yIn:"2007", dIn:"Sam Raimi", aIn:"Tobey Maguire, Kirsten Dunst, James Franco"))
        self.listWached.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMTYxMjA5NDMzNV5BMl5BanBnXkFtZTcwOTk2Mjk3NA@@._V1_SX300.jpg", tIn:"Thor", yIn:"2011", dIn:"Kenneth Branagh", aIn:"Chris Hemsworth, Natalie Portman, Tom Hiddleston"))
        self.listWached.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMTYzOTc2NzU3N15BMl5BanBnXkFtZTcwNjY3MDE3NQ@@._V1_SX300.jpg", tIn:"Captain America: The First Avenger", yIn:"2011", dIn:"Joe Johnston", aIn:"Chris Evans, Hayley Atwell, Sebastian Stan"))
        self.listWached.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMjEyNzI1ODA0MF5BMl5BanBnXkFtZTYwODIxODY3._V1_SX300.jpg", tIn:"Ice Age", yIn:"2002", dIn:"Chris Wedge, Carlos Saldanha", aIn:"Ray Romano, John Leguizamo, Denis Leary"))
        */
        //get access token from api
    
        let defaults = NSUserDefaults.standardUserDefaults()
        accesstoken = defaults.objectForKey("accesstoken") as! String
        userid = defaults.integerForKey("userid")
        if( accesstoken != ""){
            let paramWatched=[
                "page_size" : "100",
                "access_token" : accesstoken
            ]
            
            let urlWatched = "http://api.filmify.net/api/movies-watch-list/" + String(userid)
            print(urlWatched)
            
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
                            
                            self.listWached.append(movieObject(mid: movieId, pIn: poster!, tIn: title!, yIn: year!, dIn: director!, aIn: actors!, plotIn: plot, trailIn: trailer))
                            
                        }
                        self.tableWached.reloadData()
                    }else{
                        self.createAlertView("Warning", message: "Non movies in list, please add to list", buttonTitle: "OK")
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                }, error: {error in
                    //error
                }, parameters: paramWatched)
        }else{
            
        }
        
        self.tableWached.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWached.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellWached", forIndexPath: indexPath) as! customCell
        let item = listWached[indexPath.row]
        
        cell.lblTitle.text = item.title
        cell.lblYear.text = String(item.year! as Int)
        cell.lblActors.text = item.actors
        cell.lblActors.numberOfLines = 0
        cell.lblActors.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        cell.lblDirector.text = item.director
        
        //let imgUrl = NSURL(fileURLWithPath: item.poster!)
        requestImage( item.poster! ) { (image) -> Void in
            cell.poster.image = image
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let idkey:Int = indexPath!.row
        movieWatched = self.listWached[idkey]
        self.performSegueWithIdentifier("watchedDetailSegue", sender: tableView)
        
    }
    
    @IBAction func imgBack(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)

    }
    
    
    @IBAction func actionBack(sender: AnyObject) {
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
    
    @IBAction func termClick(sender: AnyObject) {
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
        if (segue.identifier == "watchedDetailSegue") {
            let svc = segue.destinationViewController as! vcResult;
            svc.movieCurrent = movieWatched
            svc.listMovies = listWached
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
