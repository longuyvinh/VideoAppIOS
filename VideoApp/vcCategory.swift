//
//  vcCategory.swift
//  VideoApp
//
//  Created by macbook on 4/21/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class vcCategory: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var viewFrameTable: UIView!
    let listGenre = ["Action", "Adventure", "Fantasy", "Animation", "Comedy" , "Comedy11"]
    
    @IBOutlet weak var myTableView: UITableView!
    
    var currentCategory:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.transform=CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        myTableView.translatesAutoresizingMaskIntoConstraints = true;

        var frame = myTableView.frame
        frame.origin.y = 0
        frame.origin.x = 0
        frame.size.width  = self.view.frame.size.width
        frame.size.height = viewFrameTable.frame.size.height
        myTableView.frame = frame
        myTableView.backgroundColor = UIColor.blackColor()
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenre.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        cell.textLabel!.text = listGenre[indexPath.row]
        
        cell.textLabel!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        cell.textLabel?.textAlignment = .Center
        
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0, green: 0.9922, blue: 0.7843, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        cell.textLabel!.font = UIFont(name:"Amatic", size:30)
        //cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {


    }
  
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.00
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        
        currentCategory = String(currentCell.textLabel!.text)
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        /*
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .redColor()
         */
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionPlay(sender: AnyObject) {
        if(currentCategory == ""){
            self.createAlertView("Warning", message: "Please choose one category", buttonTitle: "Ok")
        }else{
            self.performSegueWithIdentifier("seguePlayDetail", sender: self)
        }
    }
    
    func createAlertView(title:String, message:String, buttonTitle: String){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        
        createAccountErrorAlert.title = title
        createAccountErrorAlert.message = message
        createAccountErrorAlert.addButtonWithTitle(buttonTitle)
        
        createAccountErrorAlert.show()
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
