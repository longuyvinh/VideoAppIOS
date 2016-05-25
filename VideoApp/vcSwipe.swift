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
    
    @IBOutlet weak var collection: UICollectionView!
    let kCellIdentifier = "MyCell"
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0

    var genrePassed:Int = 0
    var listMovies = [movieObject]()
    var accesstoken:String = ""
    var frame = CGRectMake(0, 0, 0, 0)
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    //var listing:[String] =  ["item1", "item2", "item3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        let myCellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collection.registerNib(myCellNib, forCellWithReuseIdentifier: kCellIdentifier)
        
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
                self.collection.reloadData()
                
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
    
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listMovies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        //cell.configCell(<#T##title: String##String#>, year: <#T##String#>)
        cell.configCell(self.listMovies[indexPath.row].title!, year: String(self.listMovies[indexPath.row].year! as Int))
        /*
        cell.cellTitle.text = self.listMovies[indexPath.row].title
        requestImage( self.listMovies[indexPath.row].poster! ) { (image) -> Void in
            cell.cellPoster.image = image
        }*/
        
        // Make sure layout subviews
        cell.layoutIfNeeded()
        return cell
    }


    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("cell \(indexPath.row) selected")
    }
    /*
    // MARK: - UICollectionViewFlowLayout Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set up desired width
        //let targetWidth: CGFloat = (self.collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        let targetWidth: CGFloat = (self.collection.bounds.width - 3 * kHorizontalInsets)
        
        // Use fake cell to calculate height
        let reuseIdentifier = kCellIdentifier
        var cell: CollectionViewCell? = self.offscreenCells[reuseIdentifier] as? CollectionViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("MyCollectionViewCell", owner: self, options: nil)[0] as? CollectionViewCell
            self.offscreenCells[reuseIdentifier] = cell
        }
        
        // Config cell and let system determine size
        cell!.configCell(self.listMovies[indexPath.row].title!, year: String(self.listMovies[indexPath.row].year! as Int))
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRectMake(0, 0, targetWidth, cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.setNeedsLayout()
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kHorizontalInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kVerticalInsets
    }*/
    
    /*
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth:Float = 310 + 25;
        
        let currentOffSet:Float = Float(scrollView.contentOffset.x)
        
        print(currentOffSet)
        let targetOffSet:Float = Float(targetContentOffset.memory.x)
        
        print(targetOffSet)
        var newTargetOffset:Float = 0
        
        if(targetOffSet > currentOffSet){
            newTargetOffset = ceilf(currentOffSet / pageWidth) * pageWidth
        }else{
            newTargetOffset = floorf(currentOffSet / pageWidth) * pageWidth
        }
        
        if(newTargetOffset < 0){
            newTargetOffset = 0;
        }else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        
        targetContentOffset.memory.x = CGFloat(currentOffSet)
        scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated: true)
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
     */

    /*
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
        
    }*/

    


}

