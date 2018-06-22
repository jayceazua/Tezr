//
//  BottleTableViewCell.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

protocol BottleTableViewCellDelegate: class {
    func bottleTableViewCell(_ bottleCell: BottleTableViewCell, didChangeStepperTo newValue: Int)
}

class BottleTableViewCell: UITableViewCell {
    
    static let identifier = "bottle cell"
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    weak var delegate: BottleTableViewCellDelegate?
    
    var quantity: Int {
        set {
            stepper.value = Double(newValue)
            labelQuantity.text = String(newValue)
        }
        get {
            return Int(stepper.value)
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func configure(lineItem: LineItem) {
        let bottle = lineItem.item
        imageThumbnail.image = bottle.thumbnail
        labelTitle.text = bottle.title
        labelPrice.text = bottle.price.stringValue
        
        self.quantity = lineItem.quantity
        
    }
    
    // MARK: - IBACTIONS

    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func changedStepperValue(_ sender: Any) {
        delegate?.bottleTableViewCell(self, didChangeStepperTo: self.quantity)
        
        labelQuantity.text = String(self.quantity)
    }
    
    @IBOutlet weak var labelQuantity: UILabel!
    
    // MARK: - LIFE CYCLE
}
