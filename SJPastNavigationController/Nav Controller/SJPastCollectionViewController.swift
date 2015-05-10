//
//  SJPastCollectionViewController.swift
//  SJPastNavigationController
//
//  Created by Saurabh Jain on 5/9/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

/******************************
        Delegate
*******************************/

protocol SJPastCollectionViewControllerDelegate: NSObjectProtocol {
    
    func didSelectIndex(index: Int)
}

/******************************
        Collection View
*******************************/

class SJPastCollectionViewController: UIViewController {

    // Reuse identifier
    private let reuseIdentifier = "Cell"
    
    // Delegate Object
    weak var delegate: SJPastCollectionViewControllerDelegate?
    
    // Collection View
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var images = [UIImage]()
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Source & Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // background Color
        collectionView.backgroundColor = UIColor.clearColor()
        
        // Add Subview
        view.pinSubView(collectionView, top: 0, bottom: 0, left: 0, right: 0)
        
        // Layout
        let size = UIScreen.mainScreen().bounds.size
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = size
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 20.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: size.width, bottom: 0.0, right: size.width)
            layout.scrollDirection = .Horizontal
        }
        collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell classes
        collectionView.registerClass(SJPastCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // Reload the collection view
    func reload() {
        collectionView.reloadData()
        scrollToIndex(currentIndex, animated: false)
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        let width = UIScreen.mainScreen().bounds.size.width
        collectionView.setContentOffset(CGPoint(x: (width + 20) * CGFloat(index), y: 0), animated: animated)
    }
    
}

// MARK: UICollectionViewDataSource
extension SJPastCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJPastCell
        
        cell.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectIndex(indexPath.row)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}



/******************************
            Cell
*******************************/


// MARK: UICollectionViewCell
private class SJPastCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            if let image = image {
                sj_imgView.image = image
            }
        }
    }
    
    private var sj_imgView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    private func initialSetUp() {
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Background Color
        backgroundColor = UIColor.yellowColor()
        
        // Image view
        sj_imgView = UIImageView(frame: bounds)
        contentView.addSubview(sj_imgView)
        contentView.pinSubView(sj_imgView, top: 0, bottom: 0, left: 0, right: 0)
    }
    
}
