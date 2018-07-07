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
    
    private var currentCart = Cart()
    
    private var menu = StoreMenu.localStore
    
    private var collectionViews = [UICollectionView]()
    
//    private var horz
    
    // MARK: - RETURN VALUES
    
    private func sectionAt(_ indexPath: IndexPath, forCollectionView tag: Int) -> SectionItem {
        return self.menu.categories[tag].sectionItems[indexPath.section]
    }
    
    private func itemAt(_ indexPath: IndexPath, forCollectionView tag: Int) -> Item {
        return self.menu.categories[tag].sectionItems[indexPath.section].items[indexPath.row]
    }
    
    // MARK: - VOID METHODS
    
    private func initLayout() {
        let horzStackView = UIStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill
        )
        
        let nCategories = self.menu.categories.count
        
        // create collection views for each category
        for (index, _) in self.menu.categories.enumerated() {
            
            let vertStackView = UIStackView(
                axis: .vertical,
                distribution: .fill,
                alignment: .fill
            )
            
            //create collection view layout
            let collectionViewLayout = UICollectionViewFlowLayout()
            let horizontalPadding: CGFloat = 16
            collectionViewLayout.sectionInset = UIEdgeInsets(
                top: 0,
                left: horizontalPadding,
                bottom: 0,
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
            
            collectionViewLayout.headerReferenceSize = CGSize(width: menuWidth, height: 48)
            collectionViewLayout.sectionHeadersPinToVisibleBounds = true
            
            //create collection view
            let collectionView = UICollectionView(
                frame: CGRect.zero,
                collectionViewLayout: collectionViewLayout
            )
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.tag = index
            collectionView.alwaysBounceVertical = true
            
            collectionView.register(BottleCollectionViewCell.nib, forCellWithReuseIdentifier: "bottle cell")
            collectionView.register(
                MenuHeaderCollectionReusableView.nib,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MenuHeaderCollectionReusableView.identifier
            )
            vertStackView.addArrangedSubview(collectionView)
            
            //add to a stack view
            horzStackView.addArrangedSubview(vertStackView)
            
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
        
        // update page indicator
        pageIndicator.numberOfPages = nCategories
    }
    
    private func reloadMenu() {
        self.collectionViews.forEach { (aCollectionView) in
            aCollectionView.reloadData()
        }
    }
    
    //TODO: more efficent method to reload quanitities in the menu
//    private func reloadMenu(for lineItems: [LineItem]) {
//        fatalError("\(#function) not implemented")
//    }
    
    private func updateCustomerName() {
        labelHeader.text = "Welcome, \(currentCart.customerName)"
    }
    
    /**
     update subtotal and remaning balance amounts
     */
    private func updateTotalLabels() {
        labelSubtotal.text = currentCart.subtotal.stringValue
        
        if currentCart.remainingAmount > 0.0 {
            labelRemaining.text = currentCart.remainingAmount.stringValue
        } else {
            labelRemaining.text = Currency(0.0).stringValue
        }
        labelMinimum.text = currentCart.minimumSubtotal.stringValue
    }
    
    private func setPage(to index: Int, animated: Bool = true) {
        let pageWidth = scrollViewMenu.bounds.width
        let newPageOffset: CGFloat = pageWidth * CGFloat(index)
        scrollViewMenu.setContentOffset(CGPoint(x: newPageOffset, y: 0), animated: animated)
        
        segmentedView.selectedButtonIndex = index
        
        pageIndicator.currentPage = index
    }
    
    private func updatePageIndicator() {
        let pageWidth = scrollViewMenu.bounds.width
        let contentOffset = scrollViewMenu.contentOffset.x
        let currentPageIndex = Int(contentOffset / pageWidth)
        
        pageIndicator.currentPage = currentPageIndex
        
        //update segmentedView
        segmentedView.selectedButtonIndex = currentPageIndex
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var playerHeaderMovie: AVPlayerView!
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBAction func doubleTapHeader(_ sender: Any) {
        let alertName = UIAlertController(title: "Name", message: "enter a name", preferredStyle: .alert)
        alertName.addConfirmationButton(title: "Update") { [weak self] (_) in
            guard let unwrappedSelf = self else { return }
            guard
                let textField = alertName.textFields?.first,
                let newName = textField.text
                else {
                    return
            }
            
            unwrappedSelf.currentCart.customerName = newName
            unwrappedSelf.updateCustomerName()
        }
        alertName.addTextField { [weak self] (textField) in
            guard let unwrappedSelf = self else { return }

            textField.placeholder = "customer name"
            textField.autocapitalizationType = .words
            textField.text = unwrappedSelf.currentCart.customerName
        }
        self.present(alertName, animated: true)
    }
    
    @IBOutlet weak var buttonCart: UIButton!
    @IBAction func pressCart(_ sender: UIButton) {
        let cartItemsNav = CartItemsTableTableViewController.instantiateViewController(delegate: self, cart: self.currentCart)
        cartItemsNav.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popover = cartItemsNav.popoverPresentationController {
            cartItemsNav.preferredContentSize = CGSize(width: 500, height: 600)
//            popover.delegate = self
            popover.sourceView = sender
            
            self.present(cartItemsNav, animated: true)
        }
    }
    
    @IBOutlet weak var labelSubtotal: UILabel!
    @IBOutlet weak var labelRemaining: UILabel!
    
    @IBOutlet weak var labelMinimum: UILabel! {
        didSet {
            guard let doubleTitle = Double(labelMinimum.text?.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "") ?? "0") else {
                return assertionFailure("labelMinimum.text does not contain a number")
            }
            
            self.currentCart.minimumSubtotal = Currency(doubleTitle)
        }
    }
    @IBAction func doubleTapMinimum(_ sender: Any) {
        let alertMinimum = UIAlertController(title: "Minimum", message: "enter a new amount", preferredStyle: .alert)
        alertMinimum.addConfirmationButton(title: "Update") { [weak self] (_) in
            guard let unwrappedSelf = self else { return }
            guard
                let textField = alertMinimum.textFields?.first,
                let newAmount = Double(textField.text ?? "0")
                else {
                    
                    UIAlertController(title: "Update Minimum", message: "invalid amount", preferredStyle: .alert)
                        .addDismissButton()
                        .present(in: unwrappedSelf)
                    
                    return
                }
            
            unwrappedSelf.currentCart.minimumSubtotal = Currency(newAmount)
            unwrappedSelf.updateTotalLabels()
        }
        alertMinimum.addTextField { (textField) in
            textField.placeholder = "minimum amount"
            textField.keyboardType = .numberPad
        }
        self.present(alertMinimum, animated: true)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedView: SegmentedButtonView! {
        didSet {
            segmentedView.buttonTitles = self.menu.categories.map { $0.title }
        }
    }
    
    @IBOutlet weak var scrollViewMenu: UIScrollView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerHeaderMovie.loop()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadMenu()
        
        updateCustomerName()
        
        updateTotalLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //FIX: initLayout is invoked before the screen is laid out for the current device
        DispatchQueue.once(token: "StoreMenuViewController.viewDidLayoutSubviews") { [unowned self] in
            self.initLayout()
        }
    }
}

// MARK: SegmentedButtonViewDelegate

extension StoreMenuViewController: SegmentedButtonViewDelegate {
    func segmentedButton(_ segementedButtonView: SegmentedButtonView, didPressButtonAt index: Int) {
        self.setPage(to: index)
    }
}

// MARK: UICollectionViewDataSource & Delegate

extension StoreMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: RETURN VALUES
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let category = self.menu.categories[collectionView.tag]
        
        return category.sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MenuHeaderCollectionReusableView.identifier,
                for: indexPath
                ) as! MenuHeaderCollectionReusableView
            
            let section = sectionAt(indexPath, forCollectionView: collectionView.tag)
            headerView.configure(string: section.title)

            return headerView
        default:
            fatalError("unhanndled kind \(kind)")
        }
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
        
        let item = itemAt(indexPath, forCollectionView: collectionView.tag)
        cell.configure(bottle: item)
        cell.quantity = currentCart.quantity(for: item)
        cell.delegate = self
        cell.tag = collectionView.tag
        
        return cell
    }

    // MARK: VOID METHODS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemAt(indexPath, forCollectionView: collectionView.tag)
        let vc = ItemViewController.instantiateViewController(item: item)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE

}

// MARK: BottleCollectionViewCellDelegate

extension StoreMenuViewController: BottleCollectionViewCellDelegate {
    func bottleCollectionViewCell(_ bottleCell: BottleCollectionViewCell, didChangeStepperTo newValue: Int) {
        guard let indexPath = self.collectionViews[bottleCell.tag].indexPath(for: bottleCell) else {
            fatalError("index path not found for cell")
        }
        
        let item = itemAt(indexPath, forCollectionView: bottleCell.tag)
        currentCart.setQuantity(for: item, to: newValue)
        
        updateTotalLabels()
    }
}

// MARK: - ScrollViewDelegate

extension StoreMenuViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageIndicator()
    }
}

// MARK: - CartItemsTableViewControllerDelegate

extension StoreMenuViewController: CartItemsTableViewControllerDelegate {
    func cartItems(_ cartItemsController: CartItemsTableTableViewController, didFinishWith cart: Cart) {
        self.currentCart = cart
        self.currentCart.purgeLineItems()
        updateTotalLabels()
        reloadMenu()
    }
}

// MARK: - Bottle

extension Item: Bottle {
    
    var thumbnail: UIImage {
        if let imageFromName = UIImage(named: self.title) {
            return imageFromName
        } else {
            debugPrint("thumbnail not found for ->\(self.title)<-")
            
            return UIImage(named: "thumbnail-not-found")!
        }
    }
}
