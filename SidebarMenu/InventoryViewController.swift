//
//  InventoryViewController.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class InventoryViewController: UITabBarController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    var productArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
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
                    print(jsonResults.count)
                    
                    if jsonResults.count > 0 {

                        //clear coredata
                        let request = NSFetchRequest(entityName: "Product")
                    
                        request.returnsObjectsAsFaults = false
                    
                        
                        do {
                        
                            let results = try context.executeFetchRequest(request)
                        
                            if results.count > 0 {
                            
                                for result in results {
                                    
                                    
                                    
                                    context.deleteObject(result as! NSManagedObject)
                                
                                    do {
                                    
                                        try context.save()
                                    
                                    } catch {
                                    
                                        print("core data clear error")
                                
                                
                                    }
      
                                
                                }
                            
                            
                            } else {
                                
                                print("entity is empty")
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
 

}
