//
//  InventoryInfoViewController.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class InventoryInfoViewController: UIViewController {
    
    
    @IBOutlet weak var entityLabel: UILabel!

    @IBAction func setupInventory(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //hide label and button
        entityLabel.hidden = true
        
        //access core data
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        
        //setup request for entity
        let request = NSFetchRequest(entityName: "Inventory")
//        let request = NSFetchRequest(entityName: "Product")

        //request.predicate = NSPredicate(format: "product = %@", "test1")              //search the database username = fei
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let productname = result.valueForKey("name") as? String {
                        print(productname)

                    }
                    
                }
                
            } else {
                
                // show label if entity is empty
                entityLabel.hidden = false
                entityLabel.text = "Your inventory is currently empty! Please set up new inventory"
                
                }
            
        } catch {
            
            print("something happend")
            
        }

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
