//
//  vcResult.swift
//  VideoApp
//
//  Created by macbook on 4/18/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire
class vcResult: UIViewController, UIScrollViewDelegate{

    var genrePassed:Int = 0
    var userid: Int = 0
    var movieid: Int = 0
    var accesstoken:String = ""
    var movieCurrent : movieObject?
    var listMovies = [movieObject]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var scrollContent: UIScrollView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var moviePilot: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //loading view waiting
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let subviewWidth = Int(screenSize.width)
        let subviewHeight = Int(screenSize.height) - 160
        
        let subviewX:Int = Int( (Int(screenWidth) - Int(subviewWidth))/2 )
        let subviewY:Int = Int( (Int(screenHeight) - Int(subviewHeight))/2 ) + 30
        
        let myLoadingView:customLoading = customLoading(frame: CGRect(x:subviewX, y: subviewY, width: subviewWidth, height: subviewHeight))
        self.view.addSubview(myLoadingView)
        myLoadingView.tag = 90
        
        //myLoadingView.layer.cornerRadius = 12
        //myLoadingView.layer.backgroundColor = UIColor.whiteColor().CGColor
        //myLoadingView.layer.borderColor = UIColor.blackColor().CGColor
        //myLoadingView.layer.borderWidth = 1
        //myLoadingView.layer.shadowRadius = 2
        //myLoadingView.layer.cornerRadius = 12
        //loading view waiting EOF
 
        
        let youtubeLink:String = "https://www.youtube.com/embed/DOUvmXXFvEI?&playsinline=1"

        let width = self.webView.frame.width
        let height = self.webView.frame.height - 5

        self.webView.allowsInlineMediaPlayback = true
        
        let code:NSString = "<iframe width=\(width) height=\(height) src=\(youtubeLink) frameborder=\"0\" allowfullscreen></iframe>"
        
        self.webView.loadHTMLString(code as String, baseURL: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        accesstoken = defaults.objectForKey("accesstoken") as! String
        
        let paramUser = [
            "access_token": accesstoken
        ]
        
        self.movieTitle.text = ""
        self.movieYear.text = ""
        self.moviePilot.text = ""
        self.movieActors.text = ""
        self.movieDirector.text = ""
        
        let urlUser = "http://filmify.yieldlevel.co/api/user/me"
        self.getServer(urlUser, successBlock: { data in
                self.userid = data!["id"] as! Int
                if(self.userid != 0){
                    defaults.setObject(self.userid, forKey: "userid")
                    
                    if( self.genrePassed != 0){
                        self.loadDetailByGenre(self.genrePassed)
                    }else{
                        self.loadDetailById(self.movieCurrent!)
                    }
                    
                    //delay time to hide view loading
                    let seconds = 5.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        for v in self.view.subviews{
                            if (v.tag == 90) {
                                v.removeFromSuperview()
                            }
                        }
                        
                    })
                    //delay time to hide view loading EOF
                    
                }
            }, error: { error in
                //error
            }, parameters: paramUser)

    }
    
    
    func loadDetailById(movie: movieObject){
        self.movieTitle.text = movie.title
        self.movieYear.text = String(movie.year! as Int)
        self.moviePilot.text = movie.plot
        self.movieActors.text = movie.actors
        self.movieDirector.text = movie.director
        
        if let url = NSURL(string: movie.poster!) {
            if let data = NSData(contentsOfURL: url) {
                self.moviePoster.image = UIImage(data: data)
            }
        }
        
        let totalPage = CGFloat(self.listMovies.count)
        print("total page: \(totalPage)")
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * totalPage, self.viewContent.frame.height + 50)
        self.scrollView.delegate = self
        self.pageController.currentPage = 0
        /*
        self.movieCurrent = self.listMovies[0]
        self.movieTitle.text = self.movieCurrent!.title
        self.movieYear.text = String(self.movieCurrent!.year! as Int)
        self.moviePilot.text = self.movieCurrent!.plot
        self.movieActors.text = self.movieCurrent!.actors
        self.movieDirector.text = self.movieCurrent!.director
        
        if let url = NSURL(string: self.movieCurrent!.poster!) {
            if let data = NSData(contentsOfURL: url) {
                self.moviePoster.image = UIImage(data: data)
            }
        }*/
        
    }
    
    func loadDetailByGenre(genreId: Int){
        let parameters=[
            "has_poster": "true",
            "has_plot" : "true",
            "page_size" : "10",
            "genre_ids" : genreId,
            "access_token" : accesstoken
        ]
        
        let url = "http://filmify.yieldlevel.co/api/movies-by-genres"
        
        self.getServer(url, successBlock: { data in
            let jsonListing = data!["results"] as? NSArray
            //print(jsonListing)
            if(jsonListing!.count > 0){
                for item in jsonListing as! [AnyObject]{
                    //let title:String = (item.valueForKey("description") as? String)!
                    //let movie = item.valueForKey("movie")! as AnyObject
                    
                    let movieId: Int = item.valueForKey("id") as! Int
                    let poster:String? = item.valueForKey("poster") as? String
                    let title:String? = item.valueForKey("title") as? String
                    let year:Int? = item.valueForKey("year") as? Int
                    let director:String? = item.valueForKey("director") as? String
                    let actors:String? = item.valueForKey("main_cast") as? String
                    
                    let trailer: String
                    if(item.valueForKey("trailer") is NSNull){
                        trailer = "https://www.youtube.com/embed/DOUvmXXFvEI?&playsinline=1"
                    }else{
                        trailer = item.valueForKey("trailer") as! String
                    }
                    
                    let plot: String = item.valueForKey("plot") as! String
                    
                    self.listMovies.append(movieObject(mid: movieId, pIn: poster!, tIn: title!, yIn: year!, dIn: director!, aIn: actors!, plotIn: plot, trailIn: trailer))
                    //print("added success: \(movieId)")
                }
                
                let totalPage = CGFloat(self.listMovies.count)
                print("total page: \(totalPage)")
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * totalPage, self.viewContent.frame.height + 50)
                self.scrollView.delegate = self
                self.pageController.currentPage = 0
                
                self.movieCurrent = self.listMovies[0]
                self.movieTitle.text = self.movieCurrent!.title
                self.movieYear.text = String(self.movieCurrent!.year! as Int)
                self.moviePilot.text = self.movieCurrent!.plot
                self.movieActors.text = self.movieCurrent!.actors
                self.movieDirector.text = self.movieCurrent!.director
                
                if let url = NSURL(string: self.movieCurrent!.poster!) {
                    if let data = NSData(contentsOfURL: url) {
                        self.moviePoster.image = UIImage(data: data)
                    }
                }
                
            }else{
                print("none of movie")
            }
            /*
            let json = data!["results"] as! [AnyObject]
            let jsonData = json[0]
            self.movieid = jsonData.valueForKey("id") as! Int
            
            self.movieTitle.text = jsonData.valueForKey("title") as! String
            self.movieYear.text = String(jsonData.valueForKey("year") as! Int)
            self.moviePilot.text = jsonData.valueForKey("plot") as! String
            self.movieActors.text = jsonData.valueForKey("main_cast") as! String
            self.movieDirector.text = jsonData.valueForKey("director") as! String
            
            if let url = NSURL(string: jsonData.valueForKey("poster") as! String) {
                if let data = NSData(contentsOfURL: url) {
                    self.moviePoster.image = UIImage(data: data)
                }
            }*/
            }, error: { error in
            }, parameters: parameters)
        
    }


    @IBAction func addWatched(sender: AnyObject) {
            let paramSaveList = [
                "user" : userid,
                "movie": movieid,
                "access_token" : accesstoken
            ]
            let urlSave = "http://filmify.yieldlevel.co/api/watch-list/"
            
            self.postServer(urlSave, successBlock: { (data, statusCode) in
                    if(statusCode != 201){
                        self.createAlertView("Warning", message: "This movie exist in watch later list", buttonTitle: "OK")
                    }else{
                        self.createAlertView("Warning", message: "Added successful", buttonTitle: "OK")
                    }
                }, error: { error in
                    //error
                }, parameters: paramSaveList)
    }
    
    @IBAction func addWatchLater(sender: AnyObject) {
            let paramSaveList = [
                "user" : userid,
                "movie": movieid,
                "access_token" : accesstoken
            ]
            let urlSave = "http://filmify.yieldlevel.co/api/watch-later-list/"
            
            self.postServer(urlSave, successBlock: { (data, statusCode) in
                    if(statusCode != 201){
                        self.createAlertView("Warning", message: "This movie exist in watch later list", buttonTitle: "OK")
                    }else{
                        self.createAlertView("Warning", message: "Added successful", buttonTitle: "OK")
                    }
                }, error: { error in
                    //error
                }, parameters: paramSaveList)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func postServer(link: String, successBlock:(data:AnyObject?, stautusCode: Int)-> Void , error errorBlock:(error:NSError) -> Void  , parameters:AnyObject )  {
        Alamofire.request(.POST, link , parameters: parameters as? [String : AnyObject])
            .responseJSON { response in switch response.result {
                
            case .Success(let JSON):
                let data: AnyObject? = JSON
                var statusCode:Int
                statusCode = (response.response?.statusCode)!
                successBlock(data: data, stautusCode: statusCode)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                errorBlock(error: error)
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
    
    func loadDataView(){
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageController.currentPage = Int(currentPage);
        // Change the text accordingly
        
        //let totalPage = Int(self.listMovies.count)
        for (index, item) in self.listMovies.enumerate() {
            if index == Int(currentPage) {
                //print(item)
                //print(currentPage)
                
                self.movieTitle.text = item.title
                self.movieYear.text = String(item.year! as Int)
                self.moviePilot.text = item.plot
                self.movieActors.text = item.actors
                self.movieDirector.text = item.director
                
                if let url = NSURL(string: item.poster!) {
                    if let data = NSData(contentsOfURL: url) {
                        self.moviePoster.image = UIImage(data: data)
                    }
                }
                
            }
        }
        
    }
}
