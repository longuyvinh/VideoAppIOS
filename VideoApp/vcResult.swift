//
//  vcResult.swift
//  VideoApp
//
//  Created by macbook on 4/18/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit
import MediaPlayer

class vcResult: UIViewController {

    var moviePlayer : MPMoviePlayerController?
    
    @IBOutlet weak var videoPlayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //playVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func playVideo() {
        /*
        let path = NSBundle.mainBundle().pathForResource("video", ofType:"mp4")
        */
        let url = NSURL.fileURLWithPath("http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4")
        moviePlayer = MPMoviePlayerController(contentURL: url)
        if let player = moviePlayer {
            player.view.frame = self.view.bounds
            player.prepareToPlay()
            player.scalingMode = .AspectFill
            //self.view.addSubview(player.view)
            self.videoPlayer.addSubview(player.view)
        }
    }

}
