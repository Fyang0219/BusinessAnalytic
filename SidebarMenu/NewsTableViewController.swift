//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewController: UITableViewController,NSFetchedResultsControllerDelegate  {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    var productArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /*
        // save data to core data
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        
        
        
        //get JSON data from Beer API
        let url = NSURL(string: "http://ontariobeerapi.ca/products/")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    // turn json data object into NSArray
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    if jsonResults.count > 0 {
                        
                        //clear coredata
                        let request = NSFetchRequest(entityName: "Product")
                        
                        request.returnsObjectsAsFaults = false
                        
                        
                        do {
                            
                            let results = try context.executeFetchRequest(request)
                            
                            if results.count > 0 {
                                
                                for result in results {
                                    
                                    print(result.valueForKey("name"))
                                    print(result.valueForKey("id"))
                                    print(result.valueForKey("price"))
                                    print(result.valueForKey("unit"))
                                    
                                    
                                    context.deleteObject(result as! NSManagedObject)
                                    
                                    do {
                                        
                                        try context.save()
                                        
                                    } catch {
                                        
                                        print("core data clear error")
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                        }catch {
                            
                            print("FetchRequest error")
                            
                        }
                        
                        // add items into Product entity
                        for item in jsonResults {
                            
                            let fname = item["name"] as? String
                            let tempprice = item["price"] as? String
                            let fprice = Double(tempprice!)
                            let fid = item["product_id"] as? Int
                            let fsize = item["size"] as? String
                            let funit = self.findUnit(fsize!)
                            
                            if let newProduct: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: context) {
                                
                                newProduct.setValue(fname, forKey: "name")
                                newProduct.setValue(fprice, forKey: "price")
                                newProduct.setValue(fid, forKey: "id")
                                newProduct.setValue(funit, forKey: "unit")
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                } catch {
                    
                    print("error while loading json data")
                }
                
            }
            
        }
        
        task.resume()

        */
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell

        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.postTitleLabel.text = "WatchKit Introduction: Building a Simple Guess Game"
            cell.authorLabel.text = "Simon Ng"
            cell.authorImageView.image = UIImage(named: "author")

        } else if indexPath.row == 1 {
            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
            cell.postTitleLabel.text = "Building a Chat App in Swift Using Multipeer Connectivity Framework"
            cell.authorLabel.text = "Gabriel Theodoropoulos"
            cell.authorImageView.image = UIImage(named: "appcoda-300")
            
        } else {
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "A Beginner’s Guide to Animated Custom Segues in iOS 8"
            cell.authorLabel.text = "Gabriel Theodoropoulos"
            cell.authorImageView.image = UIImage(named: "appcoda-300")
            
        }

        return cell
    }
    
    
    // find unit in JSON data process
    func findUnit(largeString: String)  -> String {
        
        let a = "bottle"
        let b = "keg"
        let c = "can"
        
        if largeString.lowercaseString.rangeOfString("bottle") != nil {
            
            return a
            
        }
        
        if largeString.lowercaseString.rangeOfString("keg") != nil {
            
            return b
            
        } else {
            
            return c
            
        }
        
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
