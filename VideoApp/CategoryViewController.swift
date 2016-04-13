//
//  CategoryViewController.swift
//  VideoApp
//
//  Created by macbook on 4/8/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let appList = ["facebook", "twitter", "youtube", "instagram", "what's app"]

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132.0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "myTableCell"
        let cell = myTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        //print( indexPath.row )
        
        let item = appList[indexPath.row]
        cell.textLabel!.text = item
        return cell
    }

}
