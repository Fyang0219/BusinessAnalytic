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
    var  flagArray:NSMutableArray = []
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
        
        for (var i = 0; i < productArray.count; i++) {
            self.flagArray.addObject(false)
        }
        
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (flagArray.objectAtIndex(indexPath.row) as! Bool == true) {
            return 186
        } else {
            return 101
        }
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

        let identifier = "Custom"
        
        var cell:CustomCellListProduct! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomCellListProduct
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CustomCellListProduct", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomCellListProduct
        }
        
        if flagForResult == true
        {
            cell.lblOutlet_ProductName.text = searchResults.objectAtIndex(indexPath.row).valueForKey("name") as? String
            cell.lblOutlet_ProductPrice.text = searchResults.objectAtIndex(indexPath.row).valueForKey("price") as? String
            cell.lblOutlet_ProductUnit.text = searchResults.objectAtIndex(indexPath.row).valueForKey("unit") as? String
        }
        else
        {
            cell.lblOutlet_ProductName.text = productArray.objectAtIndex(indexPath.row).valueForKey("name") as? String
            cell.lblOutlet_ProductPrice.text = productArray.objectAtIndex(indexPath.row).valueForKey("price") as? String
            cell.lblOutlet_ProductUnit.text = productArray.objectAtIndex(indexPath.row).valueForKey("unit") as? String
        }
        
        cell.btnOutlet_Add.addTarget(self, action: "addProductToInventory:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnOutlet_Add.tag = indexPath.row + 100
        
        if (flagArray.objectAtIndex(indexPath.row) as! Bool == true) {
            cell.textField_Amount.hidden = false
            cell.textField_SellPrice.hidden = false
            cell.btnOutlet_Add.hidden = false
        } else {
            cell.textField_Amount.hidden = true
            cell.textField_SellPrice.hidden = true
            cell.btnOutlet_Add.hidden = true
        }
        
        let image_url = productArray.objectAtIndex(indexPath.row).valueForKey("image_url") as? String
        
        if let str = image_url {
            let url = NSURL(string: str as String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    if data != nil {
                        cell.imgViewOutlet_ProductImage.image = UIImage(data: data!)
                    }
                });
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for (var i = 0; i < flagArray.count; i++) {
            if i == indexPath.row {
                flagArray.replaceObjectAtIndex(i, withObject: true)
            } else {
                flagArray.replaceObjectAtIndex(i, withObject: false)
            }
        }
        obj_TableView.reloadData()
    }
    
    func addProductToInventory(let sender:UIButton) {
        
        let indexPath:NSIndexPath = NSIndexPath(forRow:sender.tag - 100, inSection: 0)
        
        let cell:CustomCellListProduct! = tableView.cellForRowAtIndexPath(indexPath) as! CustomCellListProduct

            // save data to core data
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
    
            let productName:String?
            let productPrice:Double
            let productAmount:Int
            let productImage:String?
    
            if flagForResult == true {
                productName = searchResults.objectAtIndex(sender.tag - 100).valueForKey("name") as? String
                productPrice = (cell.textField_SellPrice.text! as NSString).doubleValue
                productAmount = Int(cell.textField_Amount.text! as NSString as String)!
                productImage = searchResults.objectAtIndex(sender.tag - 100).valueForKey("image_url") as? String
            } else {
                productName = productArray.objectAtIndex(sender.tag - 100).valueForKey("name") as? String
                productPrice = (cell.textField_SellPrice.text! as NSString).doubleValue
                productAmount = Int(cell.textField_Amount.text! as NSString as String)!
                productImage = productArray.objectAtIndex(sender.tag - 100).valueForKey("image_url") as? String
            }
    
            if let newProduct: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Inventory", inManagedObjectContext: context) {
                newProduct.setValue(productName, forKey: "name")
                newProduct.setValue(productPrice, forKey: "sellPrice")
                newProduct.setValue(productAmount, forKey: "amount")
                newProduct.setValue(productImage, forKey: "image_url")
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
