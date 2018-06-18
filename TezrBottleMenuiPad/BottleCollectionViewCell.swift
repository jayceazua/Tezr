//
//  BottleCollectionViewCell.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

protocol BottleCollectionViewCellDelegate: class {
    func bottleCollectionViewCell(_ bottleCell: BottleCollectionViewCell, didChangeStepperTo newValue: Int)
}

protocol Bottle {
    var title: String { get }
    var price: Currency { get }
    var thumbnail: UIImage { get }
}

class BottleCollectionViewCell: UICollectionViewCell {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    weak var delegate: BottleCollectionViewCellDelegate?
    
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
    
    func configure(bottle: Bottle) {
        imageThumbnail.image = bottle.thumbnail
        labelTitle.text = bottle.title
        
        labelPrice.text = bottle.price.stringValue
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func changedStepperValue(_ sender: Any) {
        delegate?.bottleCollectionViewCell(self, didChangeStepperTo: self.quantity)
        
        labelQuantity.text = String(self.quantity)
    }
    
    @IBOutlet weak var labelQuantity: UILabel!
    
    // MARK: - LIFE CYCLE
}
