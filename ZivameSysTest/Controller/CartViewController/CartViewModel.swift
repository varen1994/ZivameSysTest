//
//  CartViewModel.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class CartViewModel: NSObject {

    typealias CompletionHandler = (CartData?,String?)->Void
    
    override init() {
        
    }
    
    func getCartData(completionHandler:@escaping CompletionHandler) {
        ApiManager.shared.getCartItems { (cartData, error) in
            if let products = cartData?.products {
                for obj in products {
                    let tupple = DataManager.shared.getProductsNumberOfItemInCartAndIfIsPresentInTheWishList(product: obj)
                    obj.isWishListItem = tupple.1
                    obj.numberOfItems = tupple.0
                }
                completionHandler(cartData,error)
            } else {
                 completionHandler(cartData,error)
            }
        }
    }
}
