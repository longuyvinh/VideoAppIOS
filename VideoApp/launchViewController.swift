//
//  launchViewController.swift
//  Filmily
//
//  Created by macbook on 5/26/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {

    @IBOutlet weak var playerIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.playerIcon.alpha = 0.0
            
            }, completion: nil)
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

}
