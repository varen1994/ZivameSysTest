//
//  ViewController.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import SwiftMessages

class GadgetsViewController: BaseViewController, BaseViewControllerDelegate {

    var count:Int = 0
    var cartBarButton: CustomCartBarButton?
    var viewModel = GadgetsViewModel()
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.blue
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartBarButton = CustomCartBarButton()
        self.navigationItem.rightBarButtonItem = self.cartBarButton
        self.cartBarButton?.button?.addTarget(self, action: #selector(self.clickedOnBarButtonItem), for: .touchUpInside)
        self.delegate = self
        getCartDataFromViewModel(fromPullRefresh:false)
        self.view.insertSubview(self.activityIndicator, aboveSubview: self.cartTableView)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.blue
        self.cartTableView.refreshControl = self.refreshControl
        self.refreshControl?.addTarget(self, action: #selector(self.pullRefreshSwiped), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.upDateCartItemsCount()
        self.viewModel.changeTheListOfDataWithisWishListItem(products: self.products)
        self.cartTableView.reloadData()
    }
    
    
    @objc func pullRefreshSwiped() {
         getCartDataFromViewModel(fromPullRefresh:true)
    }
    
    func getCartDataFromViewModel(fromPullRefresh:Bool) {
        if fromPullRefresh == false {
            self.activityIndicator.startAnimating()
        }
        self.viewModel.getCartData { (data, error) in
            DispatchQueue.main.async {
                if fromPullRefresh {
                    self.refreshControl?.endRefreshing()
                     self.activityIndicator.stopAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                if let error = error {
                    SwiftMessages.show(view: Helper.createAnAlertForApiError(stringMessage:error))
                } else {
                    self.products = data?.products
                    if (self.products?.count ?? 0) != 0 {
                        self.removeTableHeaderView()
                        self.cartTableView.separatorStyle = .singleLine
                        self.cartTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
                    } else {
                        self.addNoDataViewToTableView()
                    }
                    self.cartTableView.delegate = self
                    self.cartTableView.dataSource = self
                    self.cartTableView.reloadData()
                }
            }
        }
    }
    
    func upDateCartItemsCount() {
        if let items = DataManager.shared.getNumberOfWalletItems(),items > 0 {
            self.cartBarButton?.changeTag(text: "\(items)")
        } else {
            self.cartBarButton?.changeTag(text: nil)
        }
    }
    
    @objc func clickedOnBarButtonItem() {
        guard let cartVC = self.storyboard?.instantiateViewController(identifier: "CartViewController") as? CartViewController else { return }
        cartVC.products = self.products?.filter({($0.numberOfItems ?? 0) > 0})
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    
}

extension GadgetsViewController:UITableViewDataSource,UITableViewDelegate {
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


