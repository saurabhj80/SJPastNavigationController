//
//  ViewController.swift
//  SJPastNavigationController
//
//  Created by Saurabh Jain on 5/9/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, Printable {

    private let kCellIdentifier = "Cell"
    
    private let arr = ["Hello"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
    }
    
    // For debugging purposes
    override var description: String {
        get {
            return "First"
        }
    }
}

extension ViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell
        cell.textLabel?.text = arr[0]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ViewController(style: .Plain)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

