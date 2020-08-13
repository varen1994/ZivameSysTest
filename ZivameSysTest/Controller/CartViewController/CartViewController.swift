//
//  ViewController.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 12/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import SwiftMessages

class CartViewController: UIViewController {

    var count:Int = 0
    var cartBarButton: CustomCartBarButton?
    @IBOutlet weak var cartTableView: UITableView!
    var cartData:CartData?
    var viewModel = CartViewModel()
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
        self.cartTableView.separatorStyle = .none
        upDateCartItemsCount()
        registerForTheCell()
        getCartDataFromViewModel(fromPullRefresh:false)
        self.view.insertSubview(self.activityIndicator, aboveSubview: self.cartTableView)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.blue
        self.cartTableView.refreshControl = self.refreshControl
        self.refreshControl?.addTarget(self, action: #selector(self.pullRefreshSwiped), for: .valueChanged)
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
                    self.cartData = data
                    if (self.cartData?.products?.count ?? 0) != 0 {
                        self.cartTableView.separatorStyle = .singleLine
                        self.cartTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
                    }
                    self.cartTableView.delegate = self
                    self.cartTableView.dataSource = self
                    self.cartTableView.reloadData()
                }
            }
        }
    }
    
    func registerForTheCell() {
        self.cartTableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.nibName())
    }
    
    func upDateCartItemsCount() {
        if let items = DataManager.shared.getNumberOfWalletItems(),items > 0 {
            self.cartBarButton?.changeTag(text: "\(items)")
        } else {
            self.cartBarButton?.changeTag(text: nil)
        }
    }
}

extension CartViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartData?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.cartTableView.dequeueReusableCell(withIdentifier: CartTableViewCell.nibName(), for: indexPath) as? CartTableViewCell, let product = self.cartData?.products![indexPath.row] as? Product else { return UITableViewCell() }
        cell.delegate = self
        cell.initializeWith(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

extension CartViewController:CartTableViewCellDelegate {
    func moreButtonClicked(product: Product?) {
        guard let product = product else { return }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addToCartalertAction = UIAlertAction(title: "Add to Cart", style: .default) { _ in
            self.showAnimationOfProductLoadedToCart(product: product, decrement: false)
        }
        
        let tupple = DataManager.shared.getProductsNumberOfItemInCartAndIfIsPresentInTheWishList(product: product)
        let addToWishListalertAction = UIAlertAction(title: (tupple.1 == false ? "Add to wishlist" : "Remove from wishlist"), style: .default) { _ in
            self.showAnimationOfProductAddedToWishList(product: product)
        }
        
        let removeFromCart = UIAlertAction(title: "Remove from Cart", style: .default) { _ in
            self.showAnimationOfProductLoadedToCart(product: product, decrement: true)
        }
        
        alertController.addAction(addToWishListalertAction)
        alertController.addAction(addToCartalertAction)
        
        if tupple.0 > 0 {
            alertController.addAction(removeFromCart)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAnimationOfProductLoadedToCart(product:Product, decrement:Bool) {
        if decrement == false {
          product.numberOfItems = (product.numberOfItems ?? 0) + 1
        } else {
          product.numberOfItems = (product.numberOfItems ?? 0) - 1
        }
        if  DataManager.shared.incrementOrDecrementNumberOfItems(product: product) {
            if let products = self.cartData?.products {
                if let index = products.firstIndex(where: {$0.name == product.name }) {
                    guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                    let rect = self.cartTableView.rectForRow(at: IndexPath(row: index, section: 0))
                    
                    if decrement == true {
                        var imageView:UIImageView? = UIImageView(frame: CGRect(x:UIScreen.main.bounds.width-30 , y: 30, width: 10, height: 10))
                        imageView?.image = cell.itemImageView.image
                        self.showAnimationWithCompletionHandler(imageView: imageView, toFrame: CGRect(x: cell.itemImageView.frame.origin.x, y: rect.origin.y + cell.itemImageView.frame.origin.y - self.cartTableView.contentOffset.y, width: cell.itemImageView.frame.width, height: cell.itemImageView.frame.height)) { () -> (Void) in
                           self.upDateCartItemsCount()
                            cell.updateNumberOfItemsInCart()
                             imageView = nil
                        }
                    } else {
                        var imageView:UIImageView? = UIImageView(frame:CGRect(x: cell.itemImageView.frame.origin.x, y: rect.origin.y + cell.itemImageView.frame.origin.y - self.cartTableView.contentOffset.y, width: cell.itemImageView.frame.width, height: cell.itemImageView.frame.height))
                        imageView?.image = cell.itemImageView.image
                        self.showAnimationWithCompletionHandler(imageView: imageView, toFrame: CGRect(x:UIScreen.main.bounds.width-30 , y: 30, width: 10, height: 10) ) { () -> (Void) in
                           self.upDateCartItemsCount()
                           cell.updateNumberOfItemsInCart()
                           imageView = nil
                        }
                    }
                }
            }
        } else {
            
        }
    }
    
    func showAnimationWithCompletionHandler(imageView:UIImageView?,toFrame:CGRect,completionHandler:@escaping ()->(Void)) {
        self.view.insertSubview(imageView!, aboveSubview: self.cartTableView)
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            imageView!.frame = toFrame
            imageView!.alpha = 0.25
        }) { (_) in
            imageView!.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            completionHandler()
        }
    }
    
    func showAnimationOfProductAddedToWishList(product:Product) {
        product.isWishListItem = !(product.isWishListItem ?? false)
        if !DataManager.shared.addProductInToWishList(product: product) { return }
        if let products = self.cartData?.products {
            if let index = products.firstIndex(where: {$0.name == product.name }) {
                guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                UIView.animate(withDuration: 2.0, animations: {
                    cell.updateWishList()
                })
            }
        }
    }
}
