//
//  NetworkManager.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import Reachability
import Combine
import Alamofire

class NetworkManager: NSObject {

    var calledForFirstTime = false
    var reachability:Reachability?
    
    override init() {
        super.init()
        do {
          self.reachability = try Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            self.reachability?.whenReachable = { reachability in
               switch reachability.connection {
                  case .unavailable:
                    Helper.createAnAlertForNetworkFailure()
                  default:
                    return
                }
            }
          try self.reachability?.startNotifier()
        } catch {
            fatalError("Reachability Module failed")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        DispatchQueue.main.async {
            let reachability = note.object as! Reachability
            switch reachability.connection {
               case .wifi,.cellular:
                if self.calledForFirstTime == true {
                   Helper.createAnAlertForNetworkSuccessfullyJoined()
                } else{
                   self.calledForFirstTime = true
                }
                 return
               default:
                  Helper.createAnAlertForNetworkFailure()
             }
        }
        
    }
    
    func isNetworkReachable()->Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        }
         return false
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
}
