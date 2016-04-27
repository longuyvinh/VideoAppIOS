//
//  vcWatchLaterList.swift
//  VideoApp
//
//  Created by macbook on 4/19/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class vcWatchLaterList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listWachLater = [videoObject]()

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
        
        // Do any additional setup after loading the view.
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BNTE5NzU3MTYzOF5BMl5BanBnXkFtZTgwNTM5NjQxODE@._V1_SX300.jpg", tIn:"Batman v Superman: Dawn of Justice", yIn:"2016", dIn:"Zack Snyder", aIn:"Ben Affleck, Henry Cavill, Amy Adams"))
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMTY0MDY0NjExN15BMl5BanBnXkFtZTgwOTU3OTYyODE@._V1_SX300.jpg", tIn:"X-Men: Apocalypse", yIn:"2016", dIn:"Bryan Singer, Byron Howard", aIn:"Sophie Turner, Jennifer Lawrence, Olivia Munn"))
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMjQyODg5Njc4N15BMl5BanBnXkFtZTgwMzExMjE3NzE@._V1_SX300.jpg", tIn:"Deadpool", yIn:"2016", dIn:"Tim Miller", aIn:"Ryan Reynolds, Karan Soni, Ed Skrein"))
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BOTMyMjEyNzIzMV5BMl5BanBnXkFtZTgwNzIyNjU0NzE@._V1_SX300.jpg", tIn:"Zootopia", yIn:"2016", dIn:"Byron Howard", aIn:"Ginnifer Goodwin, Jason Bateman, Idris Elba"))
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMTUyMjA5OTgyOV5BMl5BanBnXkFtZTgwOTkyMjQ5NTE@._V1_SX300.jpg", tIn:"Terminus", yIn:"2015", dIn:"Marc Furmie", aIn:"Jai Koutrae, Kendra Appleton, Todd Lasance"))
        
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
        
        cell.lblYear.text = item.year
        cell.lblDirector.text = item.director
        
        cell.lblActors.text = item.actors
        cell.lblActors.numberOfLines = 0
        cell.lblActors.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        requestImage( item.poster! ) { (image) -> Void in
            cell.poster.image = image
        }
        
        return cell
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
