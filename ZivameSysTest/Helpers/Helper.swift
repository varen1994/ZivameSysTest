//
//  NetworkManagerAlert.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import SwiftMessages

class Helper: NSObject {

    class func createAnAlertForNetworkFailure() {
        let message = MessageView.viewFromNib(layout: .messageView)
        message.button?.isHidden = true
        message.titleLabel?.text = nil
        message.bodyLabel?.text = Constants.AlertString.internetNotConnected
        message.configureTheme(.error)
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3.0)
        config.presentationStyle = .top
        config.preferredStatusBarStyle = .lightContent
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: message)
    }
    
    class func createAnAlertForApiError(stringMessage:String)->MessageView {
        let message = MessageView.viewFromNib(layout: .cardView)
        message.button?.isHidden = true
        message.titleLabel?.text = nil
        message.bodyLabel?.text = stringMessage
        message.configureTheme(.error)
        return message
    }
    
    class func createAnAlertForNetworkSuccessfullyJoined() {
        let message = MessageView.viewFromNib(layout: .messageView)
        message.button?.isHidden = true
        message.titleLabel?.text = nil
        message.bodyLabel?.text = Constants.AlertString.internetConnected
        message.configureTheme(.success)
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3.0)
        config.preferredStatusBarStyle = .lightContent
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: message)
    }
}

@IBDesignable
class RoundButton:UIButton {
    @IBInspectable var cornerRadius:CGFloat = 0.0  {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
