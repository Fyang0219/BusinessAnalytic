//
//  InventoryInfoViewController.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import Charts

class InventoryInfoViewController: UIViewController {
    
    var arrayData : NSMutableArray = []
    
    @IBOutlet weak var entityLabel: UILabel!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var arrayProductName: [String]!
    var arrayProductAmount: [Double]!

    @IBAction func setupInventory(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayData = NSMutableArray()
        arrayProductName = []
        arrayProductAmount = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchFromCoreData()
    }
    
    func fetchFromCoreData() -> NSArray {
        
        if arrayData.count > 0 {
            arrayData.removeAllObjects()
        }
        
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
                barChartView.hidden = false

                for result in results as! [NSManagedObject]{
                    
                    if let productname = result.valueForKey("name") as? String {
                        print(productname)
                        
//                        let price = String(result.valueForKey("sellPrice") as! NSNumber)
                        let amount = Double(result.valueForKey("amount") as! Int)
                        
//                        let dict = NSMutableDictionary()
//                        dict .setValue(result.valueForKey("name") as? String, forKey: "name")
//                        dict.setValue(result.valueForKey("image_url") as? String, forKey: "image_url")
//                        dict .setValue(price, forKey: "sellPrice")
//                        dict .setValue(amount, forKey: "amount")
                        
//                        arrayData.addObject(dict)
                        
                        if !arrayProductName.contains(productname) {
                            arrayProductName.append(productname)
                            arrayProductAmount.append(amount)
                        }

                    }
                    
                    barChartView.noDataText = "You need to provide data for the chart."
                    
//                    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//                    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//                    
                    setChart(arrayProductName, values: arrayProductAmount)
                    
                }

            } else {
                barChartView.hidden = true
                // show label if entity is empty
                entityLabel.hidden = false
                entityLabel.text = "Your inventory is currently empty! Please set up new inventory"
                
            }
            
        } catch {
            
            print("something happend")
            
        }
        return arrayData
    }

    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: arrayProductName, dataSet: chartDataSet)
        barChartView.data = chartData
    }

}
