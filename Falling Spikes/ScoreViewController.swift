//
//  ScoreViewController.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 4/19/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func clearAllScores(sender: UIBarButtonItem) {
        HighScores.clear()
        table.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("ScoreCell")!
        let i = indexPath.row
        c.textLabel?.text = "\(HighScores.allScores[i].0) seconds"
        c.detailTextLabel?.text = HighScores.allScores[i].date
        return c
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HighScores.allScores.count
    }
    
}