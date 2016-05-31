//
//  vcSwipe.swift
//  Filmily
//
//  Created by macbook on 5/16/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcSwipe: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var genrePassed:Int = 0
    var listMovies = [movieObject]()
    var accesstoken:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIdentifier = "CollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        accesstoken = defaults.objectForKey("accesstoken") as! String
        
        let parameters=[
            "has_poster": "true",
            "has_plot" : "true",
            "page_size" : "10",
            "genre_ids" : genrePassed,
            "access_token" : accesstoken
        ]
        
        let url = "http://api.filmify.net/api/movies-by-genres"
        
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
                }
                print(self.listMovies.count)
                self.collectionView.reloadData()
                
            }else{
                print("none of movie")
            }
            }, error: { error in
            }, parameters: parameters)
        
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listMovies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.movieTitle.text = self.listMovies[indexPath.row].title
        requestImage( self.listMovies[indexPath.row].poster! ) { (image) -> Void in
            cell.moviePoster.image = image
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "dayHeaderCell", forIndexPath: indexPath) ;
        /*
        let day = sampleDataByDay[indexPath.section];
        let totalHours = day.entries.reduce(0) {(total, entry) in total + entry.hours}
        
        let dateLabel = cell.viewWithTag(1) as! UILabel
        let hoursLabel = cell.viewWithTag(2) as! UILabel
        
        dateLabel.text = day.date.stringByReplacingOccurrencesOfString(" ", withString: "\n").uppercaseString
        hoursLabel.text = String(totalHours)
        
        let hours = String(totalHours)
        let bold = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
        let text = NSMutableAttributedString(string: "\(hours)\nHOURS")
        text.setAttributes(bold, range: NSMakeRange(0, hours.characters.count))
        hoursLabel.attributedText = text
        */
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let visibleCells = collectionView.visibleCells() as? [CollectionViewCell] {
            /*
            for parallaxCell in visibleCells {
                var yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
                parallaxCell.offset(CGPointMake(0.0, yOffset))
            }*/
        }
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


}

