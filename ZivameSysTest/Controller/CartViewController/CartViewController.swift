//
//  CartViewController.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import SwiftMessages

class CartViewController: BaseViewController,BaseViewControllerDelegate {
   
    
    @IBOutlet weak var checkOutButton: RoundButton!
    lazy var activityIndicator:UIActivityIndicatorView = {
           let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
           activityIndicator.style = .large
           activityIndicator.hidesWhenStopped = true
           activityIndicator.center = self.view.center
           activityIndicator.color = UIColor.blue
           activityIndicator.stopAnimating()
           activityIndicator.backgroundColor = UIColor.white
           activityIndicator.layer.borderWidth = 2.0
           activityIndicator.layer.borderColor = UIColor.blue.cgColor
           return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(self.backButtonClicked))
        self.delegate = self
        self.upDateCartItemsCount()
    }
    
    @objc func backButtonClicked() {
        if self.view.isUserInteractionEnabled == false {
            SwiftMessages.show(view: Helper.createAnAlertForApiError(stringMessage: Constants.AlertString.operationCantCancel))
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func upDateCartItemsCount() {
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        self.removeProductsWithZeroItems()
        if (self.products?.count ?? 0) != 0 {
            self.cartTableView.separatorStyle = .singleLine
            self.cartTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
            self.removeTableHeaderView()
            self.cartTableView.separatorStyle = .singleLine
            self.cartTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.checkOutButton.isHidden = false
             self.cartTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        } else {
            self.cartTableView.separatorStyle = .none
            self.checkOutButton.isHidden = true
            self.addNoDataViewToTableView()
            self.cartTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01))
           
        }
        self.cartTableView.reloadData()
    }
    
    func removeProductsWithZeroItems() {
        guard let products = self.products else { return }
        for (index,product) in products.enumerated() where (product.numberOfItems ?? 0) == 0 {
            self.products?.remove(at: index)
        }
    }
    
    @IBAction func clickedOnCheckOutButton(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        self.view.insertSubview(self.activityIndicator, aboveSubview: self.cartTableView)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()+30) {
           self.view.isUserInteractionEnabled = true
           self.activityIndicator.stopAnimating()
           self.setAllProductsCount()
           self.products = nil
           self.upDateCartItemsCount()
           self.pushToOrderSuccessViewController()
        }
    }
    
    func pushToOrderSuccessViewController() {
        guard let orderVC = self.storyboard?.instantiateViewController(identifier: "OrderSuccessViewController") as? OrderSuccessViewController else { return }
        var children = self.navigationController?.children
        children?.removeLast()
        children?.append(orderVC)
        self.navigationController?.setViewControllers(children!, animated: true)
    }
    
    func setAllProductsCount() {
        guard let products = self.products else { return }
        for obj in products {
            obj.numberOfItems = 0
            DataManager.shared.incrementOrDecrementNumberOfItems(product: obj)
        }
    }
    
}

extension CartViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.cartTableView.dequeueReusableCell(withIdentifier: CartTableViewCell.nibName(), for: indexPath) as? CartTableViewCell, let product = self.products![indexPath.row] as? Product else { return UITableViewCell() }
        cell.delegate = self
        cell.initializeWith(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}
