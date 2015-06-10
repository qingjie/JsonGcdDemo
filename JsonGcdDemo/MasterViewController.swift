//
//  MasterViewController.swift
//  JsonGcdDemo
//
//  Created by qingjiezhao on 6/8/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController {
    
    var objects = [[String : String]]()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString : String
        println(navigationController?.tabBarItem.tag)
        if (navigationController?.tabBarItem.tag == 0){
            urlString = "http://api.whitehouse.gov/v1/petitions.json?limit=100"
        }else{
            urlString = "http://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=20"
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)) { [unowned self] in
            if let url = NSURL(string: urlString){
                if let data = NSData(contentsOfURL: url, options: .allZeros, error: nil){
                    let json = JSON( data: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        self.parseJSON(json)
                    }else{
                        self.showError()
                    }
                }else{
                    self.showError()
                }
            }else{
                self.showError()
            }
        }
    }
    
    func showError(){
        dispatch_async(dispatch_get_main_queue()){ [unowned self] in
            let ac = UIAlertController(title: "Loading error", message: "It was a problem to loading,", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func parseJSON(json : JSON){
        for result in json["results"].arrayValue{
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            
            let dict = ["title" : title, "body" : body, "sigs" : sigs]
            objects.append(dict)
        }
        dispatch_async(dispatch_get_main_queue()){ [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }
    
}