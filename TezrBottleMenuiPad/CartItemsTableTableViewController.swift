//
//  CartItemsTableTableViewController.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

protocol CartItemsTableViewControllerDelegate: class {
    func cartItems(_ cartItemsController: CartItemsTableTableViewController, didFinishWith cart: Cart)
}

//TODO: modify cart and send back to parent vc of changes made to cart

class CartItemsTableTableViewController: UITableViewController {
    
//    static func instantiate(with lineItems: [LineItems]) -> Self {
//        let storyboard = UIStoryboard(
//    }
    
    var cart: Cart! {
        didSet {
            self.listOfLineItems = cart.lineItems.map { $0.value }
        }
    }
    
    weak var delegate: CartItemsTableViewControllerDelegate?
    
    private var listOfLineItems = [LineItem]()
    
    init(cart: Cart) {
        defer {
            self.cart = cart
        }
        
        super.init(style: .plain)
        
        self.initLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initLayout()
    }
    
    // MARK: - RETURN VALUES
    
    private func itemAt(_ indexPath: IndexPath) -> Item {
        return self.listOfLineItems[indexPath.row].item
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLineItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BottleTableViewCell.identifier, for: indexPath) as! BottleTableViewCell
        
        // Configure the cell...
        let lineItem = self.listOfLineItems[indexPath.row]
        cell.configure(lineItem: lineItem)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func initLayout() {
        self.tableView.register(BottleTableViewCell.nib, forCellReuseIdentifier: BottleTableViewCell.identifier)
        self.view.backgroundColor = .black
        self.tableView.backgroundColor = .black
    }
    
    private func updateTotalLabels() {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let item = itemAt(indexPath)
            cart.setQuantity(for: item, to: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default: break
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.cartItems(self, didFinishWith: self.cart)
    }
}

extension CartItemsTableTableViewController: BottleTableViewCellDelegate {
    func bottleTableViewCell(_ bottleCell: BottleTableViewCell, didChangeStepperTo newValue: Int) {
        guard let indexPath = self.tableView.indexPath(for: bottleCell) else {
            fatalError("index path not found for cell")
        }
        
        let item = itemAt(indexPath)
        self.cart.setQuantity(for: item, to: newValue, withoutPurging: true)
        
        updateTotalLabels()
    }
}
