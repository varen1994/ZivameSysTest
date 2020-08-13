//
//  DataManager.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import CoreData

final class DataManager: NSObject {

    static let shared = DataManager()
    fileprivate let entityName = "ProductInfo"
    private override init() { }
    
    func getNumberOfWalletItems()->Int? {
        guard let products = fetchAllTheProductsFromCoreData() else { return nil }
        return products.reduce(0) { (res, info) -> Int in
            return res + Int(info.numberOfItemsCart)
        }
    }
    
    func getAllTheProductInWallet()->[Product]? {
        if let productsInfo = self.fetchAllTheProductsFromCoreData(),productsInfo.count > 0 {
           var arrayProducts = [Product]()
            for obj in productsInfo {
                let product = Product()
                product.name = obj.name
                product.image_url = obj.imageURL
                product.isWishListItem = obj.isWishListItem
                product.rating = Int(obj.rating)
                product.price = obj.price
                product.numberOfItems = Int(obj.numberOfItemsCart)
                arrayProducts.append(product)
            }
            return arrayProducts
        }
        return nil
    }
    
    func getProductsNumberOfItemInCartAndIfIsPresentInTheWishList(product:Product)->(Int,Bool) {
        if let productInfo = self.fetchCurrentObjectWithName(name: product.name!) {
            return (Int(productInfo.numberOfItemsCart),productInfo.isWishListItem)
        } else {
          return (0,false)
        }
    }
    
    
    func incrementOrDecrementNumberOfItems(product:Product)->Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        guard let name = product.name, name.count != 0 else { return false }
        let context =  appDelegate.persistentContainer.viewContext
        if let productInfo = self.fetchCurrentObjectWithName(name:name) {
            productInfo.numberOfItemsCart = Int16(product.numberOfItems ?? 0)
            productInfo.price = product.price
            productInfo.rating = Int16(product.rating ?? 0)
            do {
             try context.save()
            } catch {
                return false
            }
        } else {
           return saveProductInfoInCoreData(product: product)
        }
        return true
    }
    
    
    private func saveProductInfoInCoreData(product:Product)->Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context =  appDelegate.persistentContainer.viewContext
        let entityDescriptor = NSEntityDescription.entity(forEntityName: entityName, in: context)
             if let managedObject = NSManagedObject(entity: entityDescriptor!, insertInto: context) as? ProductInfo {
                managedObject.name = product.name
                managedObject.imageURL = product.image_url
                managedObject.isWishListItem = false
                managedObject.numberOfItemsCart = Int16(product.numberOfItems ?? 0)
                managedObject.price = product.price
                managedObject.rating = Int16(product.rating ?? 0)
                do {
                    try context.save()
                } catch {
                    print("Unable to save product")
                    return false
                }
        }
        return true
    }
    
    func addProductInToWishList(product:Product)->Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context =  appDelegate.persistentContainer.viewContext
        if let productInfo = self.fetchCurrentObjectWithName(name: product.name!) {
            productInfo.numberOfItemsCart = Int16(product.numberOfItems ?? 0)
            productInfo.price = product.price
            productInfo.isWishListItem = product.isWishListItem ?? false
            productInfo.rating = Int16(product.rating ?? 0)
            do {
             try context.save()
            } catch {
                return false
            }
        } else {
            return saveProductInfoInCoreData(product: product)
        }
        return true
    }
    
    private func fetchAllTheProductsFromCoreData()->[ProductInfo]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context =  appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
        do {
          let products = try context.fetch(fetchRequest)
          return products
        } catch {
            print("Some Error Occured while fetching Info")
            return nil
        }
    }
    
    private func fetchCurrentObjectWithName(name:String)->ProductInfo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context =  appDelegate.persistentContainer.viewContext
        let perdicate = NSPredicate(format: "name == %@", name)
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: entityName)
        fetchRequest.predicate = perdicate
        do {
          let product = try context.fetch(fetchRequest)
          return product.first
        } catch {
            print("Some Error Occured while fetching Info")
            return nil
        }
    }
}
