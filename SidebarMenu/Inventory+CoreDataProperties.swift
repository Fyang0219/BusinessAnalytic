//
//  Inventory+CoreDataProperties.swift
//  Bar Analytic
//
//  Created by Fei on 2016-04-06.
//  Copyright © 2016 AppCoda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Inventory {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var amount: NSNumber?
    @NSManaged var date: NSDate?

}
