//
//  AddToInventoryViewController.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class AddToInventoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet var viewOutlet_ProductInfo: UIView!
    @IBOutlet var imageView_ProductImage: UIImageView!
    @IBOutlet var lblOutlet_ProductName: UILabel!
    @IBOutlet var lblOutlet_ProductAmount: UILabel!
    @IBOutlet var lblOutlet_ProductSellPrice: UILabel!
    @IBOutlet var textField_ReqAmount: UITextField!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet var obj_CollectionView: UICollectionView!
    
    var array:NSMutableArray = []
    
    var myLabel = ""
    
    let pickerData = ["Current Month", "Last Month", "Two Month Ago", "Three Month Ago"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datePicker.dataSource = self
        datePicker.delegate = self
        
        obj_CollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        
        viewOutlet_ProductInfo.hidden = true
        viewOutlet_ProductInfo.layer.shadowRadius = 10.0;
        viewOutlet_ProductInfo.layer.shadowOpacity = 20;
        
        array = NSMutableArray()
        array = fetchDataProductCoreData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        testLabel.text = pickerData[row]
    }
    
    // MARK: - Collection View DataSource & Delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier : String = "CellIdentifier"
        var cell : UICollectionViewCell! = (collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)) as UICollectionViewCell
        
        if cell == nil {
            cell = UICollectionViewCell.init()
        }
        cell.backgroundColor = UIColor.clearColor()
        let label : UILabel = UILabel.init(frame: CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height))
        label.textAlignment = NSTextAlignment.Center
        label.text = array.objectAtIndex(indexPath.row) as? String
        label.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(label)
        
        let imageView : UIImageView = UIImageView.init(frame: CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height))
        imageView.backgroundColor = UIColor.blueColor()
        cell.contentView.addSubview(imageView)
        
        let image_url = array.objectAtIndex(indexPath.row).valueForKey("image_url") as? String
        
        if let str = image_url {
            let url = NSURL(string: str as String)
            
            let request : NSURLRequest = NSURLRequest(URL: url!)
            
            imageView.setImageWithURLRequest(request, placeholderImage: nil, success: {(request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                imageView.image = image
                }, failure: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width/4, collectionView.frame.size.height/4)
    }
    
    func fetchDataProductCoreData() -> NSMutableArray {
        let request = NSFetchRequest(entityName: "Inventory")
        
        
        //access core data
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let productname = result.valueForKey("name") as? String {
                        print(productname)
                        let price = String(result.valueForKey("sellPrice") as! NSNumber)
                        let amount = String(result.valueForKey("amount") as! Int)
                        
                        let dict = NSMutableDictionary()
                        dict .setValue(result.valueForKey("name") as? String, forKey: "name")
                        dict.setValue(result.valueForKey("image_url") as? String, forKey: "image_url")
                        dict .setValue(price, forKey: "sellPrice")
                        dict .setValue(amount, forKey: "amount")
                        
                        array.addObject(dict)
                    }
                    
                }
                obj_CollectionView.reloadData()
                
            } else {
                
            }
            
        } catch {
            
            print("something happend")
            
        }
        
        return array
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell : UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)! as UICollectionViewCell
        
        viewOutlet_ProductInfo.hidden = false
        lblOutlet_ProductName.text = array.objectAtIndex(indexPath.row).valueForKey("name") as? String
        lblOutlet_ProductAmount.text = array.objectAtIndex(indexPath.row).valueForKey("amount") as? String
        lblOutlet_ProductSellPrice.text = array.objectAtIndex(indexPath.row).valueForKey("sellPrice") as? String
        textField_ReqAmount.text = ""
        
        for var view : UIView in cell.contentView.subviews {
            if view.isKindOfClass(UIImageView.self) {
                imageView_ProductImage.image = (view as! UIImageView).image
            }
        }
    }
    
    @IBAction func btnClicked_Ok(sender: AnyObject) {
        viewOutlet_ProductInfo.hidden = true
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                let actualAmount : Int = Int(lblOutlet_ProductAmount.text! as NSString as String)! - Int(textField_ReqAmount.text! as NSString as String)!
                
                let userData: NSManagedObject = results[0] as! NSManagedObject
                userData.setValue(actualAmount, forKey: "amount")
                do {
                    try context.save()
                    if array.count > 0 {
                        array .removeAllObjects()
                        array = fetchDataProductCoreData()
                    }
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            } else {
                
            }
            
        } catch {
            
            print("something happend")
            
        }
    }
    
    @IBAction func btnClicked_Cancel(sender: AnyObject) {
        viewOutlet_ProductInfo.hidden = true
    }
}
