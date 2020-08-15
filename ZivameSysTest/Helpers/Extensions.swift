//
//  Extensions.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    class func nib()->UINib? {
        return UINib(nibName: self.nibName(), bundle: .main)
    }
    
    class func nibName()->String {
        return String(describing: self)
    }
    
}
