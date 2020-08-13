//
//  OrderSuccessViewController.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit

class OrderSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
    }
    
    @IBAction func continueShoppingClicked(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    


}
