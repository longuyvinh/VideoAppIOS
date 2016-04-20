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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BNTE5NzU3MTYzOF5BMl5BanBnXkFtZTgwNTM5NjQxODE@._V1_SX300.jpg", tIn:"Batman v Superman: Dawn of Justice", yIn:"2016", dIn:"Zack Snyder", aIn:"Ben Affleck, Henry Cavill, Amy Adams"))
        self.listWachLater.append(videoObject(pIn:"http://ia.media-imdb.com/images/M/MV5BMTY0MDY0NjExN15BMl5BanBnXkFtZTgwOTU3OTYyODE@._V1_SX300.jpg", tIn:"X-Men: Apocalypse", yIn:"2016", dIn:"Bryan Singer", aIn:"Sophie Turner, Jennifer Lawrence, Olivia Munn"))
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
        
        requestImage( item.poster! ) { (image) -> Void in
            cell.poster.image = image
        }
        
        return cell
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
