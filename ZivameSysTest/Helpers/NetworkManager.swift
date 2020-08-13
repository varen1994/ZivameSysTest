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

class NetworkManager: NSObject {

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
      let reachability = note.object as! Reachability
       switch reachability.connection {
          case .wifi,.cellular:
            return
          default:
             Helper.createAnAlertForNetworkFailure()
        }
    }
    
    func isNetworkReachable()->Bool {
        if let reachability = self.reachability {
            switch reachability.connection {
            case .wifi,.cellular:
                return true
            default:
                return false
            }
        }
         return false
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
}
