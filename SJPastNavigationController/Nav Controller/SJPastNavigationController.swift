//
//  SJPastNavigationController.swift
//  SJPastNavigationController
//
//  Created by Saurabh Jain on 5/9/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJPastNavigationController: UINavigationController {

    // Storing the snapshots
    private var viewControllersSnap = [UIImage]()
    
    // The long press recognizer
    private var sj_longPress: UILongPressGestureRecognizer!
    
    // The collection view
    private var collectionVC = SJPastCollectionViewController()
    
    // Background View
    private var backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // The background view
        backgroundView.backgroundColor = UIColor.grayColor()
        backgroundView.hidden = true
        view.pinSubView(backgroundView, top: 0, bottom: 0, left: 0, right: 0)
        
        // Set the collection view controller
        collectionVC.delegate = self
        
        // The long press recognizer
        sj_longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        sj_longPress.delegate = self
        navigationBar.addGestureRecognizer(sj_longPress)
        
    }
    

    override func pushViewController(viewController: UIViewController, animated: Bool){
        
        if let img = viewController.snapshotView() {
            viewControllersSnap.append(img)
        }
        
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        viewControllersSnap.removeLast()
        return super.popViewControllerAnimated(animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        viewControllersSnap.removeAll(keepCapacity: false)
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]? {
        
        var index: Int?
        for (currentIndex, currentViewController) in enumerate(viewControllers) {
            if currentViewController as? UIViewController == viewController {
                index = currentIndex
                break
            }
        }
        
        var count = 0
        for (currentIndex, image) in enumerate(viewControllersSnap) {
            if currentIndex >= index {
                count++
            }
        }
        
        for i in 0..<count {
            viewControllersSnap.removeLast()
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(viewControllers: [AnyObject]!, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        for (currentIndex, viewController) in enumerate(viewControllers) {
            if currentIndex == viewControllers.endIndex {
                break
            }
            
            if let viewController = viewController as? UIViewController {
                if let image = viewController.snapshotView() {
                    viewControllersSnap += [image]
                }
            }
            
        }
        
    }
}

// MARK: Gesture handling
extension SJPastNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let back = visibleViewController.navigationController?.navigationBar.backItem {
            let frame = CGRectMake(0, 0, 100, 50)
            let point = gestureRecognizer.locationInView(gestureRecognizer.view)
            if CGRectContainsPoint(frame, point) {
                return true
            }
        }
        
        return false
    }
    
    // Long press Gesture
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        
        if longPress.state == .Began {
            
            // Hide it
            collectionVC.view.alpha = 0
            
            // Add as a child view controller - Causing troubles
            //addChildViewController(collectionVC)
            
            // Add as subview
            let width = Float(UIScreen.mainScreen().bounds.size.width)
            NSLayoutConstraint.applyAutoLayout(view, target: collectionVC.view, top: 0, left: -width, right: -width, bottom: 0, height: nil, width: 3*width)
            
            // Did move to parent view controller
            //collectionVC.didMoveToParentViewController(self)
            
            // Click a snap
            if let image = topViewController.snapshotView() {
                viewControllersSnap.append(image)
            }
            
            // Set the images
            collectionVC.images = viewControllersSnap
            
            // Set the Index
            collectionVC.currentIndex = viewControllersSnap.count - 1
            
            // Reload the collection view
            collectionVC.reload()

            // Show the view
            self.collectionVC.view.alpha = 1
            
            // hide the navigation bar
            setNavigationBarHidden(true, animated: false)
            
            // Animate the collection view
            UIView.animateWithDuration(0.2, animations: { [unowned self] in
                self.backgroundView.hidden = false
                self.collectionVC.view.transform = CGAffineTransformMakeScale(0.7, 0.7)
            })
        }
        
    }

}

// MARK: Collection View Delegate
extension SJPastNavigationController: SJPastCollectionViewControllerDelegate {
    
    func didSelectIndex(index: Int) {
        
        if let viewControllers = self.viewControllers as? [UIViewController] {
            var destinationViewController: UIViewController?
            for (currentIndex, viewController) in enumerate(viewControllers) {
                if currentIndex == index {
                    destinationViewController = viewController
                    break
                }
            }
            
            if let viewController = destinationViewController {
                popToViewController(viewController, animated: false)
            }
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveLinear, animations:
            { [unowned self] in
                self.collectionVC.scrollToIndex(index, animated: true)
            }) { [unowned self] (finished) in
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.collectionVC.view.transform = CGAffineTransformIdentity
                }, completion: { (finished) -> Void in
                    //self.collectionVC.willMoveToParentViewController(nil)
                    self.collectionVC.view.removeFromSuperview()
                    //self.collectionVC.removeFromParentViewController()
                    self.backgroundView.hidden = true
                    self.setNavigationBarHidden(false, animated: false)
                })
            }
        }
    }
}

