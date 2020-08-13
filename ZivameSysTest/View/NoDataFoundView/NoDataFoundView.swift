//
//  NoDataFoundView.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class NoDataFoundView: UIView {

    var customView: UIView?
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        let nib = UINib(nibName: "NoDataFoundView", bundle: nil)
        customView = (nib.instantiate(withOwner: self, options: [:]).first as! UIView)
        customView!.frame = self.frame
        self.addSubview(customView!)
    }
}
