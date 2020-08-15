//
//  ProductInfo+CoreDataProperties.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductInfo> {
        return NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var rating: Int16
    @NSManaged public var numberOfItemsCart: Int16
    @NSManaged public var isWishListItem: Bool

}
