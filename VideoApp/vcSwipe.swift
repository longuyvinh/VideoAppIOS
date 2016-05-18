//
//  vcSwipe.swift
//  Filmily
//
//  Created by macbook on 5/16/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import Alamofire

class vcSwipe: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    @IBOutlet weak var scrollHorizol: UIScrollView!
    
    var genrePassed:Int = 0
    var listMovies = [movieObject]()
    var accesstoken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" show genre: \(genrePassed)")
        let defaults = NSUserDefaults.standardUserDefaults()
        accesstoken = defaults.objectForKey("accesstoken") as! String
        
        let parameters=[
            "has_poster": "true",
            "has_plot" : "true",
            "page_size" : "10",
            "genre_ids" : genrePassed,
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
                }
                
                let totalPage = CGFloat(self.listMovies.count)
                self.scrollHorizol.contentSize = CGSizeMake(self.scrollHorizol.frame.width * totalPage, self.scrollHorizol.frame.height)
                self.scrollHorizol.delegate = self
                self.pageController.currentPage = 0
                
            }else{
                print("none of movie")
            }
            }, error: { error in
            }, parameters: parameters)
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
    
    func scrollViewDidEndDecelerating(scrollHorizol: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollHorizol.frame)
        let currentPage:CGFloat = floor((scrollHorizol.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageController.currentPage = Int(currentPage);
        // Change the text accordingly
        
        //let totalPage = Int(self.listMovies.count)
        for (index, item) in self.listMovies.enumerate() {
            if index == Int(currentPage) {
                movieTitle.text = item.title
                requestImage( item.poster! ) { (image) -> Void in
                    self.moviePoster.image = image
                }
                
            }
        }
        
    }

}
