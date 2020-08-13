//
//  ApiManager.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager: NSObject {
    
    typealias CompletionHandler = (CartData?,String?)->Void
    static let shared = ApiManager()
    
    func getCartItems(completionHandler:@escaping CompletionHandler) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.networkManager.isNetworkReachable() == false {
            completionHandler(nil,Constants.AlertString.internetNotConnected)
            return
        }
        
        guard let url = URL(string: Constants.URLS.assignmentURL) else {
            completionHandler(nil,Constants.AlertString.undefinedURL);
            return
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let error = response.error?.localizedDescription {
                completionHandler(nil,error)
            } else if let data = response.data  {
                do {
                    let decoder = JSONDecoder.init()
                    let cartData = try decoder.decode(CartData.self, from: data)
                    completionHandler(cartData,nil)
                } catch {
                   completionHandler(nil,Constants.AlertString.errorOccured)
                }
            } else {
                completionHandler(nil,Constants.AlertString.errorOccured)
            }
        }
    }
}
