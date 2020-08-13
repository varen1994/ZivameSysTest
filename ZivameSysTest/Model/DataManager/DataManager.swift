//
//  DataManager.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    static let shared = DataManager()
    
    override init() {
        
    }
    
    func checkIfProductIsPresentInTheWishList()->Bool {
        return false
    }
    
    func checkIfProductIsPresentInTheWallet()->Bool {
        return false
    }
    
    func createProductInCoreData() {
        
    }
    
    func addProductInToWishList() {
        
    }
}
