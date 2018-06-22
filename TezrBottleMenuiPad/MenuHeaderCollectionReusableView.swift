//
//  MenuHeaderCollectionReusableView.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

class MenuHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "menu header view"
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(string title: String) {
        self.labelTitle.text = title
    }
    
    @IBOutlet weak var labelTitle: UILabel!
}
