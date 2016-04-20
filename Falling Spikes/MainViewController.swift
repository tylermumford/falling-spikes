//
//  MainViewController.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 4/17/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
 
    override func viewDidLoad() {
        // Hide the navigation bar WITHOUT animation on first load.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !(segue.destinationViewController is GameViewController) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func returned(segue: UIStoryboardSegue) {
        return
    }
}