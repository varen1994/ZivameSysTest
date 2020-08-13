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
            completionHandler(cartData,error)
        }
    }
}
