//
//  CartTableViewCell.swift
//  ZivameSysTest
//
//  Created by Varender Singh on 13/08/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

protocol CartTableViewCellDelegate:class {
    func moreButtonClicked(product:Product?)
}

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfItemsInCartLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    var product:Product?
    weak var delegate:CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeWith(product:Product) {
        self.product = product
        self.itemTitleLabel.text = product.name ?? "N/A"
        self.itemPriceLabel.text = "₹" + (product.price ?? "0.0")
        self.starView.rating = Double(product.rating ?? 0)
        self.updateNumberOfItemsInCart()
        self.updateWishList()
        guard let url = URL(string: product.image_url!) else { return }
        self.itemImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func moreButtonClicked(_ sender: Any) {
        self.delegate?.moreButtonClicked(product: self.product)
    }
    
    func updateNumberOfItemsInCart() {
        self.numberOfItemsInCartLabel.layer.cornerRadius = self.numberOfItemsInCartLabel.layer.frame.height/2
        self.numberOfItemsInCartLabel.layer.masksToBounds = true
        if let itemsCount = self.product?.numberOfItems,itemsCount > 0 {
            numberOfItemsInCartLabel.isHidden = false
           numberOfItemsInCartLabel.text = "\(itemsCount)"
        } else {
            numberOfItemsInCartLabel.text = nil
            numberOfItemsInCartLabel.isHidden = true
        }
    }
    
    func updateWishList() {
        if let value =  self.product?.isWishListItem,value == true {
            self.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
    }
}


