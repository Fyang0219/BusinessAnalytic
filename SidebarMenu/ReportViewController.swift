//
//  PhotoViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import Charts

class ReportViewController: UIViewController {
    
    var inventoryNames: NSMutableArray = []
    var inventorySalesAmount: NSMutableArray = []
    
    
    @IBOutlet weak var pieCharView: PieChartView!
    
    
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInventoryData () {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let productName = result.valueForKey("name") {
                        
                        inventoryNames.addObject(productName)
                        
                    }
                    
                    
                    
                }
                
                
                
            } else {
                
                print("Inventory is Empty")
            }
            
            
            
        } catch {
            
            print("something has happend while reading eneity data")
        
        }
        
        
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
