//
//  Constants.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import Foundation

struct Constants {
    
    static let baseURL = "https://my-json-server.typicode.com"
    
    struct URLS {
        static let assignmentURL = Constants.baseURL + "/nancymadan/assignment/db"
    }
    
    struct AlertString {
        static let undefinedURL = "Undefined url please try again later"
        static let errorOccured = "Some error occured please try again later"
        static let internetNotConnected = "Internet is not connected."
        static let internetConnected = "Internet is connected."
    }

}

