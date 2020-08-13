//
//  Products.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class CartData:Codable {
    var products:[Product]?
}

class Product:Codable {
    var name:String?
    var price:String?
    var image_url:String?
    var rating:Int?
    var isWishListItem:Bool?
    var numberOfItems:Int?
}

