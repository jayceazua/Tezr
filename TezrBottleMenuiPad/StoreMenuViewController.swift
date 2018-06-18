//
//  StoreMenuViewController.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

class StoreMenuViewController: UIViewController {
    
    private var menu = StoreMenu.localStore
    
//    private var horz
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func initLayout() {
        let horzStackView = UIStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill
        )
        
        // create collection views for each category
        let colors: [UIColor] = [.red, .blue, .green, .yellow]
        for aColor in colors {
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.backgroundColor = aColor
            
            //add to a stack view
            horzStackView.addArrangedSubview(colorView)
        }
        
        // layout stack view in scrollview to allow paging through the collection views
        self.scrollViewMenu.addSubview(horzStackView)
        horzStackView.topAnchor.constraint(equalTo: scrollViewMenu.topAnchor)
        horzStackView.leadingAnchor.constraint(equalTo: scrollViewMenu.leadingAnchor)
        horzStackView.trailingAnchor.constraint(equalTo: scrollViewMenu.trailingAnchor)
        horzStackView.bottomAnchor.constraint(equalTo: scrollViewMenu.bottomAnchor)
        horzStackView.heightAnchor.constraint(equalTo: scrollViewMenu.heightAnchor)
        horzStackView.widthAnchor.constraint(equalTo: scrollViewMenu.widthAnchor, multiplier: CGFloat(colors.count))
        NSLayoutConstraint.activate(horzStackView.constraints)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let identifier = segue.identifier {
     switch identifier {
     case <#pattern#>:
     <#code#>
     default:
     break
     }
     }
     }*/
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelRemaining: UILabel!
    @IBOutlet weak var labelMinimum: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollViewMenu: UIScrollView!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }

}
