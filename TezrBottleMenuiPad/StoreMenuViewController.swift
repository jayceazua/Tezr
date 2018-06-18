//
//  StoreMenuViewController.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

class StoreMenuViewController: UIViewController {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
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
        
    }

}
