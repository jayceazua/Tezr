//
//  StoreMenuViewController.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

class StoreMenuViewController: UIViewController {
    
    //TODO: create model
    
    private var menu = StoreMenu.localStore
    
    private var collectionViews = [UICollectionView]()
    
//    private var horz
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func initLayout() {
        let horzStackView = UIStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill
        )
        
        let nCategories = self.menu.categories.count
        
        // create collection views for each category
        for index in 0..<nCategories {
            
            //TODO: create category header label
            let collectionViewLayout = UICollectionViewFlowLayout()
            let horizontalPadding: CGFloat = 16
            collectionViewLayout.sectionInset = UIEdgeInsets(
                top: 20,
                left: horizontalPadding,
                bottom: 10,
                right: horizontalPadding
            )
            
            //cell width
            let cellSize: CGSize
            let menuWidth = self.scrollViewMenu.bounds.width
            if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
                cellSize = CGSize(width: menuWidth / 2 - (horizontalPadding * 2), height: 58)
            } else {
                cellSize = CGSize(width: menuWidth - (horizontalPadding * 2), height: 58)
            }
            collectionViewLayout.itemSize = cellSize
            
            let collectionView = UICollectionView(
                frame: CGRect.zero,
                collectionViewLayout: collectionViewLayout
            )
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.tag = index
            
            collectionView.register(BottleCollectionViewCell.nib, forCellWithReuseIdentifier: "bottle cell")
            
            //add to a stack view
            horzStackView.addArrangedSubview(collectionView)
            
            self.collectionViews.append(collectionView)
        }
        
        // layout stack view in scrollview to allow paging through the collection views
        self.scrollViewMenu.addSubview(horzStackView)
        horzStackView.topAnchor.constraint(equalTo: scrollViewMenu.topAnchor).isActive = true
        horzStackView.leadingAnchor.constraint(equalTo: scrollViewMenu.leadingAnchor).isActive = true
        horzStackView.trailingAnchor.constraint(equalTo: scrollViewMenu.trailingAnchor).isActive = true
        horzStackView.bottomAnchor.constraint(equalTo: scrollViewMenu.bottomAnchor).isActive = true
        horzStackView.heightAnchor.constraint(equalTo: scrollViewMenu.heightAnchor).isActive = true
        horzStackView.widthAnchor.constraint(equalTo: scrollViewMenu.widthAnchor, multiplier: CGFloat(nCategories)).isActive = true
    }
    
    private func reloadMenu() {
        self.collectionViews.forEach { (aCollectionView) in
            aCollectionView.reloadData()
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadMenu()
    }

}

// MARK: UICollectionViewDataSource & Delegate

extension StoreMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let category = self.menu.categories[collectionView.tag]
        
        return category.sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = self.menu.categories[collectionView.tag]
        let section = category.sectionItems[section]
        
        return section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottle cell", for: indexPath) as? BottleCollectionViewCell else {
            fatalError("bottle cell not registered, or not a BottleCollectionViewCell")
        }
        
//        let item = self.menu.categories[collectionView.tag].sectionItems[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    
}
