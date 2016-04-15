//
//  CustomCellListProduct.swift
//  Bar Analytic
//
//  Created by Fei on 4/15/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CustomCellListProduct: UITableViewCell,UISearchBarDelegate {

    @IBOutlet var imgViewOutlet_ProductImage: UIImageView!
    @IBOutlet var lblOutlet_ProductName: UILabel!
    @IBOutlet var lblOutlet_ProductPrice: UILabel!
    @IBOutlet var lblOutlet_ProductUnit: UILabel!
    @IBOutlet var textField_Amount: UITextField!
    @IBOutlet var textField_SellPrice: UITextField!
    @IBOutlet var btnOutlet_Add: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
