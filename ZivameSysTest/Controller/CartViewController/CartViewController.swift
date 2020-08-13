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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartBarButton = CustomCartBarButton()
        self.navigationItem.rightBarButtonItem = self.cartBarButton
        registerForTheCell()
        getCartDataFromViewModel()
    }
    
    func getCartDataFromViewModel() {
        self.viewModel.getCartData { (data, error) in
            DispatchQueue.main.async {
                if let error = error {
                    SwiftMessages.show(view: Helper.createAnAlertForApiError(stringMessage:error))
                } else {
                    self.cartData = data
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
        let addToWishListalertAction = UIAlertAction(title: "Add to Wishlist", style: .default) { _ in
            self.showAnimationOfProductAddedToWishList(product: product)
        }
        let addToCartalertAction = UIAlertAction(title: "Add to Cart", style: .default) { _ in
            self.showAnimationOfProductLoadedToCart(product: product)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addToWishListalertAction)
        alertController.addAction(addToCartalertAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAnimationOfProductLoadedToCart(product:Product) {
        if let products = self.cartData?.products {
            if let index = products.firstIndex(where: {$0.name == product.name }) {
                guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                let rect = self.cartTableView.rectForRow(at: IndexPath(row: index, section: 0))
                var imageView:UIImageView? = UIImageView(frame: CGRect(x: cell.itemImageView.frame.origin.x, y: rect.origin.y + cell.itemImageView.frame.origin.y - self.cartTableView.contentOffset.y, width: cell.itemImageView.frame.width, height: cell.itemImageView.frame.height))
                imageView?.image = cell.itemImageView.image
                self.view.insertSubview(imageView!, aboveSubview: self.cartTableView)
                UIView.animate(withDuration: 2.0, animations: {
                    imageView!.frame = CGRect(x:UIScreen.main.bounds.width-30 , y: 30, width: 10, height: 10)
                    imageView!.alpha = 0.25
                }) { (_) in
                    imageView!.removeFromSuperview()
                    imageView = nil
                    self.count += 1
                    self.cartBarButton?.changeTag(text:"\(self.count)")
                }
            }
        }
    }
    
    func showAnimationOfProductAddedToWishList(product:Product) {
        if let products = self.cartData?.products {
            if let index = products.firstIndex(where: {$0.name == product.name }) {
                guard let cell = self.cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartTableViewCell else { return }
                UIView.animate(withDuration: 2.0, animations: {
                    cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
                }) { (_) in
                    cell.contentView.backgroundColor = UIColor.white
                }
            }
        }
    }
}
