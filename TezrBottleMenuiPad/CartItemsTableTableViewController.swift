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
    
    static func instantiateViewController(delegate: CartItemsTableViewControllerDelegate, cart: Cart) -> UINavigationController {
        let vc = CartItemsTableTableViewController(cart: cart)
        vc.delegate = delegate
        let nc = UINavigationController(rootViewController: vc)
        
        //add buttons
        let submitButton = UIBarButtonItem(title: "Submit", style: .done, target: vc, action: #selector(pressSubmit(_:)))
        let clearButton = UIBarButtonItem(title: "Clear Cart", style: .plain, target: vc, action: #selector(pressClearCart(_:)))
        let flexiableDivider = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        vc.navigationController!.isToolbarHidden = false
        vc.setToolbarItems([submitButton, flexiableDivider, clearButton], animated: false)
        
        return nc
    }
    
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
        self.tableView.backgroundColor = .black    }
    
    private func updateTotalLabels() {
        self.title = "Subtotal: \(cart.subtotal.stringValue)"
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
    
    @objc private func pressSubmit(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func pressClearCart(_ button: UIBarButtonItem) {
        
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTotalLabels()
    }
    
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
