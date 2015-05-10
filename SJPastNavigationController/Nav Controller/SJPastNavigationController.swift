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
        let width = Float(UIScreen.mainScreen().bounds.size.width)
        NSLayoutConstraint.applyAutoLayout(view, target: collectionVC.view, top: 0, left: -width, right: -width, bottom: 0, height: nil, width: 3*width)
        
        // Hide it
        collectionVC.view.alpha = 0.0
        
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
        
        var removeList = [Bool]()
        for (currentIndex, image) in enumerate(viewControllersSnap) {
            if currentIndex >= index {
                removeList += [true]
            } else {
                removeList += [false]
            }
        }
        for (currentIndex, shouldRemove) in enumerate(removeList) {
            if shouldRemove {
                if let index = index {
                    viewControllersSnap.removeAtIndex(index)
                }
            }
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
    
    // Gesture delegate
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
            
            if let image = topViewController.snapshotView() {
                viewControllersSnap.append(image)
            }
            
            collectionVC.images = viewControllersSnap
            collectionVC.currentIndex = viewControllersSnap.count - 1
            collectionVC.reload()
            collectionVC.view.alpha = 1
            
            backgroundView.hidden = false
            
            setNavigationBarHidden(true, animated: false)
            UIView.animateWithDuration(0.5, animations: { [unowned self] in
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
            
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
                self.collectionVC.view.transform = CGAffineTransformIdentity
                self.collectionVC.scrollToIndex(index, animated: false)
                }) { (finished) in
                    self.backgroundView.hidden = true
                    self.collectionVC.view.alpha = 0.0
                    self.setNavigationBarHidden(false, animated: false)
            }
        }

    }
    
}

