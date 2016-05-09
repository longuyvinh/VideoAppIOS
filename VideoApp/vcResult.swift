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
    var genrePassed:Int = 0
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let youtubeLink:String = "https://www.youtube.com/embed/DOUvmXXFvEI?&playsinline=1"
        
        let width = self.webView.frame.width
        let height = self.webView.frame.height - 5

        self.webView.allowsInlineMediaPlayback = true
        
        let code:NSString = "<iframe width=\(width) height=\(height) src=\(youtubeLink) frameborder=\"0\" allowfullscreen></iframe>"
        
        self.webView.loadHTMLString(code as String, baseURL: nil)
        
        print("show id: \(self.genrePassed)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
}
