//
//  ItemViewController.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/22/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var item: Item!
    
    init(item: Item) {
        self.item = item
        
        super.init(nibName: "ItemViewController", bundle: nil)
        
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initLayout()
    }
    
    // MARK: - RETURN VALUES
    
    static func instantiateViewController(item: Item) -> UINavigationController {
        let vc = ItemViewController(item: item)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
    }
    
    // MARK: - VOID METHODS
    
    private func initLayout() {
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
