//
//  BaseViewController.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit


protocol BaseViewControllerDelegate:class {
    func upDateCartItemsCount()
}


@IBDesignable
class BaseViewController: UIViewController {

    @IBInspectable var isGagetListVC:Bool = false {
        didSet {
            
        }
    }
    weak var delegate:BaseViewControllerDelegate?
     var products:[Product]? = nil
     @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTableView.separatorInset = .zero
        self.cartTableView.separatorStyle = .none
        registerForTheCell()
    }
    
    func registerForTheCell() {
        self.cartTableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.nibName())
    }
    
    func addNoDataViewToTableView() {
        let noDataView = NoDataFoundView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        self.cartTableView.tableHeaderView = noDataView
        self.cartTableView.reloadData()
    }
    
    func removeTableHeaderView() {
        self.cartTableView.tableHeaderView = nil
        self.cartTableView.reloadData()
    }
    
}

extension BaseViewController:CartTableViewCellDelegate {
    func moreButtonClicked(product: Product?) {
        guard let product = product else { return }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addToCartalertAction = UIAlertAction(title: Constants.AlertString.addToCart, style: .default) { _ in
            self.showAnimationOfProductLoadedToCart(product: product, decrement: false)
        }
        
        let tupple = DataManager.shared.getProductsNumberOfItemInCartAndIfIsPresentInTheWishList(product: product)
        let addToWishListalertAction = UIAlertAction(title: (tupple.1 == false ? Constants.AlertString.addWishList :  Constants.AlertString.removeWishList), style: .default) { _ in
            self.showAnimationOfProductAddedToWishList(product: product)
        }
        
        let removeFromCart = UIAlertAction(title: Constants.AlertString.removeFromCart, style: .default) { _ in
            self.showAnimationOfProductLoadedToCart(product: product, decrement: true)
        }
        
        alertController.addAction(addToWishListalertAction)
        alertController.addAction(addToCartalertAction)
        
        if tupple.0 > 0 {
            alertController.addAction(removeFromCart)
        }
        
        let cancelAction = UIAlertAction(title: Constants.AlertString.cancel, style: .cancel, handler: nil)
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
            if let products = self.products {
                if let index = products.firstIndex(where: {$0.name == product.name }) {
                    guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                    let rect = self.cartTableView.rectForRow(at: IndexPath(row: index, section: 0))
                    
                    if decrement == true {
                        var imageView:UIImageView? = UIImageView(frame: CGRect(x:UIScreen.main.bounds.width-30 , y: 30, width: 10, height: 10))
                        imageView?.image = cell.itemImageView.image
                        self.showAnimationWithCompletionHandler(imageView: imageView, toFrame: CGRect(x: cell.itemImageView.frame.origin.x, y: rect.origin.y + cell.itemImageView.frame.origin.y - self.cartTableView.contentOffset.y, width: cell.itemImageView.frame.width, height: cell.itemImageView.frame.height)) { () -> (Void) in
                           if let delegate = self.delegate {
                                delegate.upDateCartItemsCount()
                            }
                            cell.updateNumberOfItemsInCart()
                            imageView = nil
                        }
                    } else {
                        var imageView:UIImageView? = UIImageView(frame:CGRect(x: cell.itemImageView.frame.origin.x, y: rect.origin.y + cell.itemImageView.frame.origin.y - self.cartTableView.contentOffset.y, width: cell.itemImageView.frame.width, height: cell.itemImageView.frame.height))
                        imageView?.image = cell.itemImageView.image
                        self.showAnimationWithCompletionHandler(imageView: imageView, toFrame: CGRect(x:UIScreen.main.bounds.width-30 , y: 30, width: 10, height: 10) ) { () -> (Void) in
                            if let delegate = self.delegate {
                                delegate.upDateCartItemsCount()
                            }
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
        if isGagetListVC == false {  completionHandler();
            return
        }
        self.view.insertSubview(imageView!, aboveSubview: self.cartTableView)
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.2, animations: {
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
        if let products = self.products {
            if let index = products.firstIndex(where: {$0.name == product.name }) {
                guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                UIView.animate(withDuration: 2.0, animations: {
                    cell.updateWishList()
                })
            }
        }
    }
}
