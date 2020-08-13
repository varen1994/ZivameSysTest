//
//  CustomCartBarButton.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class CustomCartBarButton: UIBarButtonItem {

    var button:UIButton?
    var textBadge:UILabel?
    
    override init() {
        super.init()
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.button!.setImage(UIImage(named: "CartIcon"), for: .normal)
        self.textBadge = UILabel(frame: CGRect(x: 15, y: 0, width: 15, height: 15))
        self.textBadge!.text = nil
        self.textBadge?.font = UIFont.systemFont(ofSize: 10.0)
        self.textBadge?.textAlignment = .center
        self.textBadge!.backgroundColor = UIColor.red
        self.textBadge!.layer.cornerRadius = textBadge!.layer.frame.height/2
        self.textBadge!.layer.masksToBounds = true
        self.textBadge?.textColor = UIColor.systemBlue
        self.button!.addSubview(textBadge!)
        self.customView = button
        self.textBadge!.isHidden = true
    }
    
    func changeTag(text:String?) {
        self.textBadge?.text = text
        self.textBadge?.isHidden = (text == nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
