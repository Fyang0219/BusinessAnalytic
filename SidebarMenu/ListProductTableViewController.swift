//
//  ListProductTableViewController.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class ListProductTableViewController: UITableViewController, UISearchBarDelegate, NSURLSessionDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    var searchResults:NSMutableArray = []
    var productArray:NSMutableArray = []
    var flagForResult:Bool?
    @IBOutlet var obj_TableView: UITableView!
    
    /*
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var filterdProducts = ["1", "2", "3"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filterdProducts = filterdProducts.filter( item in return item.model.lowercaseString.containString(searchText.lowercaseString)
        
        }
    
    
    }
      */
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        searchResults = NSMutableArray();
        productArray = NSMutableArray()
        
        productArray = fetchDataProductCoreData()
        print(productArray.count)
        
        /*
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchDataProductCoreData() -> NSMutableArray {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let array:NSMutableArray = NSMutableArray()
        
        //setup request for entity
        let request = NSFetchRequest(entityName: "Product")
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let productname = result.valueForKey("name") as? String {
                        
                        let dict = NSMutableDictionary()
                        let price = String(result.valueForKey("price") as! NSNumber)
                        dict .setValue(result.valueForKey("name") as? String, forKey: "name")
                        dict .setValue(price, forKey: "price")
                        dict .setValue(result.valueForKey("unit") as? String, forKey: "unit")
                        dict.setValue(result.valueForKey("image_url") as? String, forKey: "image_url")
                        array.addObject(dict)
                       
                        print(productname)
                        
                        
                        
                    }
                    
                }
                
            } else {
                
            }
            
        } catch {
            
            print("something happend")
            
        }
        return array
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if flagForResult == true
        {
            return searchResults.count
        }
        else {
            return productArray.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        for sub in cell.contentView.subviews{//scan all subviews of wrapper
            if sub .isKindOfClass(UILabel) {
                sub.removeFromSuperview()//remove them
            }
        }
        
        let lbl_Name:UILabel = UILabel.init(frame: CGRectMake(60, 0, self.view.frame.size.width - 60, 21))
        let lbl_Price:UILabel = UILabel.init(frame: CGRectMake(60, 21, self.view.frame.size.width - 60, 21))
        let lbl_Unit:UILabel = UILabel.init(frame: CGRectMake(60, 42, self.view.frame.size.width - 60, 21))
        let imgView_Product:UIImageView = UIImageView.init(frame: CGRectMake(0, 0, 50, 50))

        if flagForResult == true
        {
            lbl_Name.text = searchResults.objectAtIndex(indexPath.row).valueForKey("name") as? String
            lbl_Price.text = searchResults.objectAtIndex(indexPath.row).valueForKey("price") as? String
            lbl_Unit.text = searchResults.objectAtIndex(indexPath.row).valueForKey("unit") as? String
        }
        else
        {
            lbl_Name.text = productArray.objectAtIndex(indexPath.row).valueForKey("name") as? String
            lbl_Price.text = productArray.objectAtIndex(indexPath.row).valueForKey("price") as? String
            lbl_Unit.text = productArray.objectAtIndex(indexPath.row).valueForKey("unit") as? String
        }
        let image_url = productArray.objectAtIndex(indexPath.row).valueForKey("image_url") as? String
        
        if let str = image_url {
            let url = NSURL(string: str as String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    if data != nil {
                        imgView_Product.image = UIImage(data: data!)
                    }
                });
            }
        }
        
        cell.contentView.addSubview(lbl_Name)
        cell.contentView.addSubview(lbl_Price)
        cell.contentView.addSubview(lbl_Unit)
        cell.contentView.addSubview(imgView_Product)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // save data to core data
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
//        let fname = item["name"] as? String
//        let tempprice = item["price"] as? String
//        let fprice = Double(tempprice!)
//        let fid = item["product_id"] as? Int
//        let fsize = item["size"] as? String
//        let funit = self.findUnit(fsize!)
//        let image_Url = item["image_url"] as? String
        
        let productName:String?
        let productPrice:Double
        let productUnit:String?
        let productDate:String?

        if flagForResult == true {
            productName = searchResults.objectAtIndex(indexPath.row).valueForKey("name") as? String
            productPrice = (searchResults.objectAtIndex(indexPath.row).valueForKey("price") as? NSString)!.doubleValue
            productUnit = searchResults.objectAtIndex(indexPath.row).valueForKey("unit") as? String
            productDate = searchResults.objectAtIndex(indexPath.row).valueForKey("price") as? String
        } else {
            productName = productArray.objectAtIndex(indexPath.row).valueForKey("name") as? String
            productPrice = (productArray.objectAtIndex(indexPath.row).valueForKey("price") as? NSString)!.doubleValue
            productUnit = productArray.objectAtIndex(indexPath.row).valueForKey("unit") as? String
            productDate = productArray.objectAtIndex(indexPath.row).valueForKey("price") as? String
        }
        
        if let newProduct: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Inventory", inManagedObjectContext: context) {
            
            newProduct.setValue(productName, forKey: "name")
            newProduct.setValue(productPrice, forKey: "sellPrice")
//            newProduct.setValue(productUnit, forKey: "amount")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        cancelButtonOutlet.hidden = NO;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            flagForResult = false
            obj_TableView.reloadData()
        }
        
        if productArray.count > 0 {
            searchResults.removeAllObjects()
            for (var i = 0; i < productArray.count; i++) {
                let tmp: NSString = (productArray.objectAtIndex(i).valueForKey("name"))! as! NSString
                let nameRange:NSRange = tmp.rangeOfString(searchText, options:(NSStringCompareOptions.CaseInsensitiveSearch))
                if nameRange.location != NSNotFound {
                    flagForResult = true
                    searchResults.addObject(productArray.objectAtIndex(i))
                    obj_TableView.reloadData()
                } else {
                    obj_TableView.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        obj_TableView.reloadData()
        self.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchResults.count > 0 {
            flagForResult = true
            searchBar .resignFirstResponder()
            obj_TableView.reloadData()
        } else {
            flagForResult = false
            searchBar .resignFirstResponder()
            obj_TableView.reloadData()
        }
    }
    
   /* - (IBAction)searchCancelButtonClicked:(id)sender
    {
    cancelButtonOutlet.hidden = YES;
    searchBar.text = @"";
    flagForResult = NO;
    [searchBar resignFirstResponder];
    [collectionViewOutlet reloadData];
    [tblViewAtoZListingOutlet reloadData];
    } */

}
